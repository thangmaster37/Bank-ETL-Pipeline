-- models/staging/dimensions/stg_dim_customers.sql

{{
    config(
        materialized='incremental',
        alias='stg_dim_customers',
        schema=var('staging_bank_schema'),
        unique_key='customer_id',
        incremental_strategy='delete+insert'
    )
}}

WITH new_dim_customers AS (
    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY LOWER(TRIM("phone_number"))
            ORDER BY "customer_id" ASC
        ) AS "rank_customer"

    FROM 
        {{ source('staging_snowflake', 'dim_customers') }}
)

SELECT
    "customer_id",
    LOWER(TRIM("first_name")) AS "first_name",
    LOWER(TRIM("last_name")) AS "last_name",
    LOWER(CONCAT(TRIM("first_name"), ' ', TRIM("last_name"))) AS "full_name",
    CASE
        WHEN "email" LIKE '%_@__%.__%' THEN TRIM("email")
        ELSE NULL
    END AS "email",
    {{ parse_address("address") }},
    LOWER(TRIM("city")) AS "city",
    LOWER(TRIM("state")) AS "state",
    "postal_code",
    REGEXP_REPLACE(LOWER("phone_number"), '[^0-9+\-x.()]+', '') AS "phone_number"

FROM 
    new_dim_customers

WHERE -- Loại bỏ các record chứa giá trị NULL
      "customer_id" IS NOT NULL
  AND "first_name" IS NOT NULL
  AND "last_name" IS NOT NULL
  AND "email" IS NOT NULL
  AND "city" IS NOT NULL
  AND "state" IS NOT NULL
  AND "postal_code" IS NOT NULL
  AND "phone_number" IS NOT NULL
      -- Loại bỏ các record có rank_customer lớn hơn 1
  AND "rank_customer" = 1

ORDER BY "customer_id"