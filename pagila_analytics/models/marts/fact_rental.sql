SELECT
    rental_id,
    rental_date,
    return_date,
    inventory_id,
    customer_id,
    staff_id,
    rental_duration_hours,
    payment_amount
FROM {{ ref('int_rental_facts') }}