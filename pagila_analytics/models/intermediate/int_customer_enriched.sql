WITH customer AS (
    SELECT * FROM {{ ref('stg_customer') }}
),
address AS (
    SELECT * FROM {{ ref('stg_address') }}
),
city AS (
    SELECT * FROM {{ ref('stg_city') }}
),
country AS (
    SELECT * FROM {{ ref('stg_country') }}
),
joined AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email,
        c.activebool,
        c.create_date,
        a.address,
        a.district,
        a.postal_code,
        a.phone,
        ci.city,
        co.country
    FROM customer c
    LEFT JOIN address a ON c.address_id = a.address_id
    LEFT JOIN city ci ON a.city_id = ci.city_id
    LEFT JOIN country co ON ci.country_id = co.country_id
)
SELECT * FROM joined