WITH source AS (
    SELECT * FROM {{ source('pagila', 'COUNTRY') }}
),
renamed AS (
    SELECT
        COUNTRY_ID AS country_id,
        COUNTRY AS country,
        LAST_UPDATE AS last_update
    FROM source
)
SELECT * FROM renamed