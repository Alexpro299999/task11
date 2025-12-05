SELECT
    f.title
FROM {{ ref('dim_film') }} f
LEFT JOIN {{ ref('stg_inventory') }} i ON f.film_id = i.film_id
WHERE i.inventory_id IS NULL