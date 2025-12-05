WITH source AS (
    SELECT * FROM {{ source('pagila', 'FILM_ACTOR') }}
),
renamed AS (
    SELECT
        ACTOR_ID AS actor_id,
        FILM_ID AS film_id,
        LAST_UPDATE AS last_update
    FROM source
)
SELECT * FROM renamed
