WITH payment_film AS (
    SELECT
        p.amount,
        i.film_id
    FROM {{ ref('fact_revenue') }} p
    JOIN {{ ref('stg_rental') }} r ON p.rental_id = r.rental_id
    JOIN {{ ref('stg_inventory') }} i ON r.inventory_id = i.inventory_id
)
SELECT
    f.category_name,
    SUM(pf.amount) AS total_revenue
FROM payment_film pf
JOIN {{ ref('dim_film') }} f ON pf.film_id = f.film_id
GROUP BY f.category_name
ORDER BY total_revenue DESC
LIMIT 1