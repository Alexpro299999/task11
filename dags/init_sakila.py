from datetime import datetime
from airflow import DAG
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from config import SCRIPTS_PATH

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

    create_schema >> populate_data