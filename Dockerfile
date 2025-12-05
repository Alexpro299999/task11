FROM apache/airflow:2.9.2

USER root
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
         build-essential \
  && apt-get autoremove -yqq --purge \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

USER airflow
# Ставим фиксированную версию, чтобы не ломать ядро Airflow
RUN pip install apache-airflow-providers-airbyte==4.0.0 apache-airflow-providers-mysql