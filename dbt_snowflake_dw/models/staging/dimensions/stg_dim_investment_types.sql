-- models/staging/dimensions/stg_dim_investment_types.sql

{{
    config(
        materialized='incremental',
        alias='stg_dim_investment_types',
        schema=var('staging_bank_schema'),
        unique_key='investment_type_id',
        incremental_strategy='delete+insert'
    )
}}

WITH new_dim_investment_types AS (
    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY LOWER(TRIM("investment_type_name"))
            ORDER BY "investment_type_id" ASC
        ) AS "rank_investment_type"

    FROM 
        {{ source('staging_snowflake', 'dim_investment_types') }}
)

SELECT
    "investment_type_id",
    LOWER(TRIM("investment_type_name")) AS "investment_type_name"

FROM 
    new_dim_investment_types

WHERE -- Loại bỏ các record chứa giá trị NULL
      "investment_type_id" IS NOT NULL
  AND "investment_type_name" IS NOT NULL
      -- Loại bỏ các kiểu đầu tư không có trong ngân hàng
  AND "investment_type_name" NOT IN ('key investment', 'happen investment', 'nation investment', 'power investment', 'special investment')
      -- Loại bỏ các record có rank_investment_type lớn hơn 1
  AND "rank_investment_type" = 1

ORDER BY "investment_type_id"