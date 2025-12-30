WITH base_data AS (
    SELECT
        c.city,
        f.category_name,
        r.rental_duration_hours
    FROM {{ ref('fact_rental') }} r
    JOIN {{ ref('dim_customer') }} c ON r.customer_id = c.customer_id
    JOIN {{ ref('stg_inventory') }} i ON r.inventory_id = i.inventory_id
    JOIN {{ ref('dim_film') }} f ON i.film_id = f.film_id
),
category_rental_hours AS (
    SELECT
        CASE
            WHEN city ILIKE 'a%' THEN 'Cities starting with "a"'
            WHEN city LIKE '%-%' THEN 'Cities with a "-"'
        END AS city_group,
        category_name,
        SUM(rental_duration_hours) AS total_rental_hours
    FROM base_data
    WHERE city ILIKE 'a%' OR city LIKE '%-%'
    GROUP BY 1, 2
),
ranked_categories AS (
    SELECT
        city_group,
        category_name,
        total_rental_hours,
        RANK() OVER (PARTITION BY city_group ORDER BY total_rental_hours DESC) as rnk
    FROM category_rental_hours
)
SELECT
    city_group,
    category_name,
    total_rental_hours
FROM ranked_categories
WHERE rnk = 1