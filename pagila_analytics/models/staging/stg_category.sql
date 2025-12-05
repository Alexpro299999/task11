WITH source AS (
    SELECT * FROM {{ source('pagila', 'CATEGORY') }}
),
renamed AS (
    SELECT
        CATEGORY_ID AS category_id,
        NAME AS name,
        LAST_UPDATE AS last_update
    FROM source
)
SELECT * FROM renamed