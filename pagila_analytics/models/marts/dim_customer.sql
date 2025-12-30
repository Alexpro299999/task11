SELECT
    customer_id,
    first_name,
    last_name,
    email,
    address,
    city,
    country,
    activebool as is_active,
    create_date
FROM {{ ref('int_customer_enriched') }}