-- models/staging/dimensions/stg_dim_locations.sql

{{
    config(
        materialized='incremental',
        alias='stg_dim_locations',
        unique_key='location_id',
        incremental_strategy='delete+insert'
    )
}}

WITH new_dim_locations AS (
    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY 
                LOWER(TRIM("address")), 
                LOWER(TRIM("city")), 
                LOWER(TRIM("state")),
                LOWER(TRIM("country"))
            ORDER BY "location_id" ASC
        ) AS "rank_location"

    FROM 
        {{ source('raw_snowflake', 'dim_locations') }}
)

SELECT
    "location_id",
    {{ parse_address("address") }},
    LOWER(TRIM("city")) AS "city",
    LOWER(TRIM("state")) AS "state",
    LOWER(TRIM("country")) AS "country",
    "postal_code"

FROM 
    new_dim_locations

WHERE -- Loại bỏ các record chứa giá trị NULL
      "location_id" IS NOT NULL
  AND "address" IS NOT NULL
  AND "city" IS NOT NULL
  AND "state" IS NOT NULL
  AND "country" IS NOT NULL
  AND "postal_code" IS NOT NULL
      -- Loại bỏ các record có rank_location lớn hơn 1
  AND "rank_location" = 1

ORDER BY "location_id"