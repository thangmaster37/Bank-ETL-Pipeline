-- models/staging/facts/stg_fact_customer_interactions.sql

{{
    config(
        materialized='incremental',
        alias='stg_fact_customer_interactions',
        unique_key='interaction_id',
        incremental_strategy='delete+insert'
    )
}}

WITH new_fact_customer_interactions AS (
    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY "interaction_id"
            ORDER BY "interaction_id" ASC
        ) AS "rank_customer_interaction"

    FROM 
        {{ source('raw_snowflake', 'fact_customer_interactions') }}
)

SELECT
    "interaction"."interaction_id",
    "interaction"."date_id",
    "interaction"."channel_id",
    "interaction"."location_id",
    "interaction"."customer_id",
    LOWER(TRIM("interaction"."interaction_type")) AS "interaction_type",
    "interaction"."interaction_rating"

FROM 
    new_fact_customer_interactions AS "interaction"

    {{ inner_join_id("raw_snowflake", "dim_dates", "interaction", "date", "date_id", "date_id") }}
    {{ inner_join_id("raw_snowflake", "dim_channels", "interaction", "channel", "channel_id", "channel_id") }}
    {{ inner_join_id("raw_snowflake", "dim_locations", "interaction", "location", "location_id", "location_id") }}
    {{ inner_join_id("raw_snowflake", "dim_customers", "interaction", "customer", "customer_id", "customer_id") }}

    -- INNER JOIN 
    --     {{ source('raw_snowflake', 'dim_dates') }} AS "date"
    --     ON "interaction"."date_id" = "date"."date_id"

    -- INNER JOIN 
    --     {{ source('raw_snowflake', 'dim_channels') }} AS "channel"
    --     ON "interaction"."channel_id" = "channel"."channel_id"

    -- INNER JOIN 
    --     {{ source('raw_snowflake', 'dim_locations') }} AS "location"
    --     ON "interaction"."location_id" = "location"."location_id"

    -- INNER JOIN 
    --     {{ source('raw_snowflake', 'dim_channels') }} AS "channel"
    --     ON "interaction"."channel_id" = "channel"."channel_id"

WHERE -- Loại bỏ các record chứa giá trị NULL
      "interaction"."interaction_id" IS NOT NULL
  AND "interaction"."date_id" IS NOT NULL
  AND "interaction"."channel_id" IS NOT NULL
  AND "interaction"."location_id" IS NOT NULL
  AND "interaction"."customer_id" IS NOT NULL
  AND "interaction"."interaction_type" IS NOT NULL
  AND "interaction"."interaction_rating" IS NOT NULL
      -- Loại bỏ các kiểu tương tác của khách hàng không có trong ngân hàng
  AND "interaction"."interaction_type" NOT IN ('phone call', 'email', 'in-person', 'chat', 'social media')
      -- Loại bỏ các record có rating ngoài khoảng 1-5
  AND "interaction"."interaction_rating" BETWEEN 1 AND 5
      -- Loại bỏ các record có rank_customer_interaction lớn hơn 1
  AND "interaction"."rank_customer_interaction" = 1

ORDER BY "interaction"."interaction_id"