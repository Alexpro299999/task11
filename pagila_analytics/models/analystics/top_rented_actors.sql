WITH rental_data AS (
    SELECT
        r.rental_id,
        i.film_id
    FROM {{ ref('fact_rental') }} r
    JOIN {{ ref('stg_inventory') }} i ON r.inventory_id = i.inventory_id
),
actor_rentals AS (
    SELECT
        fab.first_name,
        fab.last_name,
        COUNT(rd.rental_id) AS rental_count
    FROM rental_data rd
    JOIN {{ ref('int_film_actor_bridge') }} fab ON rd.film_id = fab.film_id
    GROUP BY fab.first_name, fab.last_name
)
SELECT
    first_name,
    last_name,
    rental_count
FROM actor_rentals
ORDER BY rental_count DESC
LIMIT 10