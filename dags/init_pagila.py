from datetime import datetime
from airflow import DAG
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from config import SCRIPTS_PATH

default_args = {
    'owner': 'airflow',
    'start_date': datetime(2024, 1, 1),
}

with DAG(
    dag_id='init_pagila_db',
    default_args=default_args,
    schedule=None,
    catchup=False,
    template_searchpath=[SCRIPTS_PATH],
    tags=['pagila', 'setup']
) as dag:

    drop_schema = SQLExecuteQueryOperator(
        task_id='drop_schema',
        conn_id='postgres_pagila_conn',
        sql="""
            DROP SCHEMA public CASCADE;
            CREATE SCHEMA public;
            GRANT ALL ON SCHEMA public TO pagila_user;
            GRANT ALL ON SCHEMA public TO public;
        """
    )

    create_schema = SQLExecuteQueryOperator(
        task_id='create_schema',
        conn_id='postgres_pagila_conn',
        sql='pagila-schema.sql'
    )

    populate_data = SQLExecuteQueryOperator(
        task_id='populate_data',
        conn_id='postgres_pagila_conn',
        sql='pagila-insert-data.sql'
    )

    drop_schema >> create_schema >> populate_data