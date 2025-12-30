WITH source AS (
    SELECT * FROM {{ source('pagila', 'FILM_CATEGORY') }}
),
renamed AS (
    SELECT
        FILM_ID AS film_id,
        CATEGORY_ID AS category_id,
        LAST_UPDATE AS last_update
    FROM source
)
SELECT * FROM renamed