WITH source AS (
    SELECT * FROM {{ source('pagila', 'FILM') }}
),
renamed AS (
    SELECT
        FILM_ID AS film_id,
        TITLE AS title,
        DESCRIPTION AS description,
        RELEASE_YEAR AS release_year,
        LANGUAGE_ID AS language_id,
        RENTAL_DURATION AS rental_duration,
        RENTAL_RATE AS rental_rate,
        LENGTH AS length,
        REPLACEMENT_COST AS replacement_cost,
        RATING AS rating,
        SPECIAL_FEATURES AS special_features,
        LAST_UPDATE AS last_update
    FROM source
)
SELECT * FROM renamed