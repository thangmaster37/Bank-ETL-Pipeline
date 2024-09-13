-- models/staging/dimensions/stg_dim_dates.sql

{{
    config(
        materialized='incremental',
        alias='stg_dim_dates',
        schema=var('staging_bank_schema'),
        unique_key='date_id',
        incremental_strategy='delete+insert'
    )
}}

WITH new_dim_dates AS (
    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY "date"
            ORDER BY "date_id" ASC
        ) AS "rank_date"

    FROM 
        {{ source('staging_snowflake', 'dim_dates') }}
)

SELECT
    "date_id",
    "date",
    "day",
    "month",
    "year",
    "quarter",
    "weekday"

FROM 
    new_dim_dates

WHERE -- Loại bỏ các record chứa giá trị NULL
      "date_id" IS NOT NULL
  AND "date" IS NOT NULL
  AND "day" IS NOT NULL
  AND "month" IS NOT NULL
  AND "year" IS NOT NULL
  AND "quarter" IS NOT NULL
  AND "weekday" IS NOT NULL
      -- Loại bỏ các record có rank_date lớn hơn 1
  AND "rank_date" = 1

ORDER BY "date_id"