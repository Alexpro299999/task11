WITH film AS (
    SELECT * FROM {{ ref('stg_film') }}
),
language AS (
    SELECT * FROM {{ ref('stg_language') }}
),
film_category AS (
    SELECT * FROM {{ ref('stg_film_category') }}
),
category AS (
    SELECT * FROM {{ ref('stg_category') }}
),
joined AS (
    SELECT
        f.film_id,
        f.title,
        f.description,
        f.release_year,
        l.name AS language,
        c.name AS category_name,
        f.rental_duration,
        f.rental_rate,
        f.length,
        f.rating
    FROM film f
    LEFT JOIN language l ON f.language_id = l.language_id
    LEFT JOIN film_category fc ON f.film_id = fc.film_id
    LEFT JOIN category c ON fc.category_id = c.category_id
)
SELECT * FROM joined