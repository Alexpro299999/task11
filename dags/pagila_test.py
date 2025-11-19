from datetime import datetime
from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator

default_args = {
    'owner': 'airflow',
    'start_date': datetime(2024, 1, 1),
}

with DAG(
    dag_id='test_pagila_connection',
    default_args=default_args,
    schedule_interval=None,
    catchup=False,
    tags=['pagila']
) as dag:

    count_films = PostgresOperator(
        task_id='count_films',
        postgres_conn_id='postgres_pagila_conn',
        sql='SELECT COUNT(*) FROM public.film;'
    )