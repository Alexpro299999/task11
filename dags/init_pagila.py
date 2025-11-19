from datetime import datetime
from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator

SCRIPTS_PATH = '/opt/airflow/scripts'

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

    create_schema = PostgresOperator(
        task_id='create_schema',
        postgres_conn_id='postgres_pagila_conn',
        sql='pagila-schema.sql'
    )

    populate_data = PostgresOperator(
        task_id='populate_data',
        postgres_conn_id='postgres_pagila_conn',
        sql='pagila-insert-data.sql'
    )

    create_schema >> populate_data