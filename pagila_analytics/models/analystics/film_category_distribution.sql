SELECT
    category_name,
    COUNT(film_id) AS film_count
FROM {{ ref('dim_film') }}
GROUP BY category_name
ORDER BY film_count DESC
