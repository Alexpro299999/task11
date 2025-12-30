WITH actor_counts AS (
    SELECT
        fab.first_name,
        fab.last_name,
        COUNT(fab.film_id) AS film_count
    FROM {{ ref('int_film_actor_bridge') }} fab
    JOIN {{ ref('dim_film') }} f ON fab.film_id = f.film_id
    WHERE f.category_name = 'Children'
    GROUP BY fab.actor_id, fab.first_name, fab.last_name
),
ranked_actors AS (
    SELECT
        first_name,
        last_name,
        film_count,
        RANK() OVER (ORDER BY film_count DESC) as actor_rank
    FROM actor_counts
)
SELECT
    first_name,
    last_name,
    film_count
FROM ranked_actors
WHERE actor_rank <= 3