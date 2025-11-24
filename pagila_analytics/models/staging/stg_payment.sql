WITH source AS (
    SELECT * FROM {{ source('pagila', 'PAYMENT') }}
),
renamed AS (
    SELECT
        PAYMENT_ID AS payment_id,
        CUSTOMER_ID AS customer_id,
        STAFF_ID AS staff_id,
        RENTAL_ID AS rental_id,
        AMOUNT AS amount,
        PAYMENT_DATE AS payment_date
    FROM source
)
SELECT * FROM renamed