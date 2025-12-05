WITH source AS (
    SELECT * FROM {{ source('pagila', 'RENTAL') }}
),
renamed AS (
    SELECT
        RENTAL_ID AS rental_id,
        RENTAL_DATE AS rental_date,
        INVENTORY_ID AS inventory_id,
        CUSTOMER_ID AS customer_id,
        RETURN_DATE AS return_date,
        STAFF_ID AS staff_id,
        LAST_UPDATE AS last_update
    FROM source
)
SELECT * FROM renamed