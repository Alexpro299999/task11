WITH source AS (
    SELECT * FROM {{ source('pagila', 'ACTOR') }}
),
renamed AS (
    SELECT
        ACTOR_ID AS actor_id,
        FIRST_NAME AS first_name,
        LAST_NAME AS last_name,
        LAST_UPDATE AS last_update
    FROM source
)
SELECT * FROM renamed