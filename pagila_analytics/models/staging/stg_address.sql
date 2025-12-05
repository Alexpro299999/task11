WITH source AS (
    SELECT * FROM {{ source('pagila', 'ADDRESS') }}
),
renamed AS (
    SELECT
        ADDRESS_ID AS address_id,
        ADDRESS AS address,
        ADDRESS2 AS address2,
        DISTRICT AS district,
        CITY_ID AS city_id,
        POSTAL_CODE AS postal_code,
        PHONE AS phone,
        LAST_UPDATE AS last_update
    FROM source
)
SELECT * FROM renamed