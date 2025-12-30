WITH source AS (
    SELECT * FROM {{ source('pagila', 'LANGUAGE') }}
),
renamed AS (
    SELECT
        LANGUAGE_ID AS language_id,
        NAME AS name,
        LAST_UPDATE AS last_update
    FROM source
)
SELECT * FROM renamed