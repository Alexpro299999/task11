from datetime import datetime
from airflow import DAG
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from airflow.providers.airbyte.operators.airbyte import AirbyteTriggerSyncOperator
from config import SCRIPTS_PATH

AIRBYTE_SAKILA_CONNECTION_ID = 'b4023c7b-2b30-4a9f-a7c7-2fd7635bbc82'

default_args = {
    'owner': 'airflow',
    'start_date': datetime(2024, 1, 1),
}

with DAG(
    dag_id='init_sakila_mysql_db',
    default_args=default_args,
    schedule=None,
    catchup=False,
    template_searchpath=[SCRIPTS_PATH],
    tags=['sakila', 'mysql', 'setup']
) as dag:

    create_schema = SQLExecuteQueryOperator(
        task_id='create_schema',
        conn_id='mysql_sakila_conn',
        sql='sakila-mysql-clean.sql'
    )

    populate_data = SQLExecuteQueryOperator(
        task_id='populate_data',
        conn_id='mysql_sakila_conn',
        sql='sakila-mysql-clean-data.sql'
    )

    trigger_airbyte = AirbyteTriggerSyncOperator(
        task_id='trigger_airbyte_sakila',
        airbyte_conn_id='airbyte_conn',
        connection_id=AIRBYTE_SAKILA_CONNECTION_ID,
        asynchronous=False,
        timeout=3600,
        wait_seconds=3
    )

    create_schema >> populate_data >> trigger_airbyte