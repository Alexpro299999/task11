WITH source AS (
    SELECT * FROM {{ source('pagila', 'CITY') }}
),
renamed AS (
    SELECT
        CITY_ID AS city_id,
        CITY AS city,
        COUNTRY_ID AS country_id,
        LAST_UPDATE AS last_update
    FROM source
)
SELECT * FROM renamed