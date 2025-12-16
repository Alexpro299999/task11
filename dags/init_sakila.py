from datetime import datetime
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.providers.airbyte.operators.airbyte import AirbyteTriggerSyncOperator

AIRBYTE_SAKILA_CONNECTION_ID = 'b4023c7b-2b30-4a9f-a7c7-2fd7635bbc82'
DOWNLOAD_URL = "https://downloads.mysql.com/docs/sakila-db.tar.gz"
SCHEMA_PATH = "/opt/airflow/scripts/sakila-schema.sql"
DATA_PATH = "/opt/airflow/scripts/sakila-data.sql"

default_args = {
    'owner': 'airflow',
    'start_date': datetime(2024, 1, 1),
}

with DAG(
    dag_id='init_sakila_mysql_db',
    default_args=default_args,
    schedule=None,
    catchup=False,
    tags=['sakila', 'mysql', 'setup']
) as dag:

    download_files = BashOperator(
        task_id='download_files',
        bash_command=f"mkdir -p /opt/airflow/scripts && curl -L {DOWNLOAD_URL} | tar xz -C /opt/airflow/scripts --strip-components=1"
    )

    init_db = BashOperator(
        task_id='init_db',
        bash_command=f"""
            mysql -h mysql-sakila -P 3306 -u sakila_user -psakila_password sakila < {SCHEMA_PATH} && \\
            mysql -h mysql-sakila -P 3306 -u sakila_user -psakila_password sakila < {DATA_PATH}
        """
    )

    trigger_airbyte = AirbyteTriggerSyncOperator(
        task_id='trigger_airbyte_sakila',
        airbyte_conn_id='airbyte_conn',
        connection_id=AIRBYTE_SAKILA_CONNECTION_ID,
        asynchronous=False,
        timeout=3600,
        wait_seconds=3
    )

    download_files >> init_db >> trigger_airbyte