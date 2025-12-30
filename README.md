

\*\*\*



\# Pagila \& Sakila Analytics Pipeline



Full ELT pipeline using \*\*Docker, Airflow, Airbyte, Snowflake, and dbt\*\*.



\## 1. Launch Infrastructure



You need to run two separate docker-compose stacks.



\*\*A. Start Airflow \& Databases (Pagila/Sakila):\*\*

Run in the root directory:

```bash

docker-compose up -d --build

```



\*\*B. Start Airbyte:\*\*

Run in the `airbyte\_infra` directory:

```bash

cd airbyte\_infra

docker-compose up -d

```



\*   \*\*Airflow:\*\* \[http://localhost:8080](http://localhost:8080) (User/Pass: `airflow` / `airflow`)

\*   \*\*Airbyte:\*\* \[http://localhost:8000](http://localhost:8000) (User/Pass: `airbyte` / `password`)



---



\## 2. Configure Airbyte



1\.  \*\*Sources:\*\* Create sources using your machine's \*\*local Network IP\*\* (e.g., `192.168.x.x` or `10.x.x.x`), NOT `localhost`.

&nbsp;   \*   \*\*Postgres (Pagila):\*\* Port `5433`, User `pagila\_user`, Pass `pagila\_password`.

&nbsp;   \*   \*\*MySQL (Sakila):\*\* Port `3307`, User `sakila\_user`, Pass `sakila\_password`.

2\.  \*\*Destination:\*\* Snowflake (Role `AIRBYTE\_ROLE`, DB `RAW\_DATA`).

3\.  \*\*Connections:\*\*

&nbsp;   \*   Set \*\*Destination Namespace\*\* to \*\*Custom Format\*\*: `PAGILA` (for Postgres) and `SAKILA` (for MySQL).

&nbsp;   \*   \*\*Important:\*\* Copy the \*\*Connection IDs\*\* (UUIDs from the URL) and update them in `dags/init\_pagila.py` and `dags/init\_sakila.py`.



---



\## 3. Configure Airflow Connections



Go to \*\*Admin -> Connections\*\* and add these three:



| Conn Id | Type | Host | Port | Login | Password | Schema |

| :--- | :--- | :--- | :--- | :--- | :--- | :--- |

| `postgres\_pagila\_conn` | Postgres | `postgres-pagila` | `5432` | `pagila\_user` | `pagila\_password` | `pagila` |

| `mysql\_sakila\_conn` | MySQL | `mysql-sakila` | `3306` | `sakila\_user` | `sakila\_password` | `sakila` |

| `airbyte\_conn` | Airbyte | `http://airbyte:password@YOUR\_LOCAL\_IP:8000` | - | - | - | - |



\*> Note for Airbyte Conn: Pass credentials directly in the Host URL to avoid auth issues.\*



---



\## 4. Run Pipeline



1\.  Go to Airflow DAGs.

2\.  Trigger \*\*`init\_pagila\_db`\*\* and \*\*`init\_sakila\_mysql\_db`\*\*.

&nbsp;   \*   \*This will init DBs, populate data, and trigger Airbyte sync.\*



---



\## 5. Run dbt (Analytics)



We use \*\*dbt-snowflake\*\*. The `profiles.yml` is included in the repo for review purposes.



1\.  Install dbt:

&nbsp;   ```bash

&nbsp;   pip install dbt-snowflake

&nbsp;   ```

2\.  Run models (from `pagila\_analytics` folder):

&nbsp;   ```bash

&nbsp;   cd pagila\_analytics

&nbsp;   dbt debug --profiles-dir .

&nbsp;   dbt run --profiles-dir .

&nbsp;   ```



\*Check results in Snowflake under `ANALYTICS.DBT\_DEV` views.\*

