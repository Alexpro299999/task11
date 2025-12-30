WITH source AS (
    SELECT * FROM {{ source('pagila', 'CUSTOMER') }}
),
renamed AS (
    SELECT
        CUSTOMER_ID AS customer_id,
        STORE_ID AS store_id,
        FIRST_NAME AS first_name,
        LAST_NAME AS last_name,
        EMAIL AS email,
        ADDRESS_ID AS address_id,
        ACTIVEBOOL AS activebool,
        CREATE_DATE AS create_date,
        LAST_UPDATE AS last_update,
        ACTIVE AS active
    FROM source
)
SELECT * FROM renamed