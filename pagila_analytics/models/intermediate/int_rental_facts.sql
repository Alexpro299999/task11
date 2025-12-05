WITH rental AS (
    SELECT * FROM {{ ref('stg_rental') }}
),
payment AS (
    SELECT * FROM {{ ref('stg_payment') }}
),
joined AS (
    SELECT
        r.rental_id,
        r.rental_date,
        r.return_date,
        r.inventory_id,
        r.customer_id,
        r.staff_id,
        DATEDIFF(hour, r.rental_date, r.return_date) AS rental_duration_hours,
        p.amount AS payment_amount,
        p.payment_date
    FROM rental r
    LEFT JOIN payment p ON r.rental_id = p.rental_id
)
SELECT * FROM joined