from datetime import datetime
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.providers.airbyte.operators.airbyte import AirbyteTriggerSyncOperator

SCHEMA_URL = "https://raw.githubusercontent.com/devrimgunduz/pagila/master/pagila-schema.sql"
DATA_URL = "https://raw.githubusercontent.com/devrimgunduz/pagila/master/pagila-insert-data.sql"

SCHEMA_PATH = "/opt/airflow/scripts/pagila-schema.sql"
DATA_PATH = "/opt/airflow/scripts/pagila-data.sql"

AIRBYTE_PAGILA_CONNECTION_ID = 'fefe9132-05b4-4b9f-a708-44d222ea5fc4'

default_args = {
    'owner': 'airflow',
    'start_date': datetime(2024, 1, 1),
}

with DAG(
    dag_id='init_pagila_db',
    default_args=default_args,
    schedule=None,
    catchup=False,
    tags=['pagila', 'setup']
) as dag:

    download_files = BashOperator(
        task_id='download_files',
        bash_command=f"curl -L {SCHEMA_URL} -o {SCHEMA_PATH} && curl -L {DATA_URL} -o {DATA_PATH}"
    )

    init_db = BashOperator(
        task_id='init_db',
        bash_command=f"""
            PGPASSWORD=pagila_password psql -h postgres-pagila -U pagila_user -d pagila -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;" && \\
            PGPASSWORD=pagila_password psql -h postgres-pagila -U pagila_user -d pagila -f {SCHEMA_PATH} && \\
            PGPASSWORD=pagila_password psql -h postgres-pagila -U pagila_user -d pagila -f {DATA_PATH}
        """
    )

    trigger_airbyte = AirbyteTriggerSyncOperator(
        task_id='trigger_airbyte_pagila',
        airbyte_conn_id='airbyte_conn',
        connection_id=AIRBYTE_PAGILA_CONNECTION_ID,
        asynchronous=False,
        timeout=3600,
        wait_seconds=3
    )

    download_files >> init_db >> trigger_airbyte