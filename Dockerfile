FROM apache/airflow:2.9.2

USER root

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
         build-essential \
         default-mysql-client \
         postgresql-client \
  && apt-get autoremove -yqq --purge \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

USER airflow

RUN pip install apache-airflow-providers-airbyte==3.8.1 apache-airflow-providers-mysql