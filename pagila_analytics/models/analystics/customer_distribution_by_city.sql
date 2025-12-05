SELECT
    city,
    COUNT(CASE WHEN is_active = TRUE THEN 1 END) AS active_count,
    COUNT(CASE WHEN is_active = FALSE THEN 1 END) AS inactive_count
FROM {{ ref('dim_customer') }}
GROUP BY city
ORDER BY inactive_count DESC