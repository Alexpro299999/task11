WITH film AS (
    SELECT * FROM {{ ref('stg_film') }}
),
actor AS (
    SELECT * FROM {{ ref('stg_actor') }}
),
film_actor AS (
    SELECT * FROM {{ ref('stg_film_actor') }}
),
joined AS (
    SELECT
        f.film_id,
        f.title,
        a.actor_id,
        a.first_name,
        a.last_name
    FROM film f
    JOIN film_actor fa ON f.film_id = fa.film_id
    JOIN actor a ON fa.actor_id = a.actor_id
)
SELECT * FROM joined