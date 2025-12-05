WITH source AS (
    SELECT * FROM {{ source('pagila', 'INVENTORY') }}
),
renamed AS (
    SELECT
        INVENTORY_ID AS inventory_id,
        FILM_ID AS film_id,
        STORE_ID AS store_id,
        LAST_UPDATE AS last_update
    FROM source
)
SELECT * FROM renamed