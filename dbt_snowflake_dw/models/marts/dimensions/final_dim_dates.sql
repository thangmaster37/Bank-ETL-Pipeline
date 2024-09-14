-- models/marts/dimensions/final_dim_dates.sql

{{
    config(
        materialized='incremental',
        alias='final_dim_dates',
        unique_key='date_id',
        incremental_strategy='merge'
    )
}}

SELECT 
    "date_id",
    "date",
    "day",
    "month",
    "year",
    "quarter",
    "weekday"

FROM 
    {{ source('staging_snowflake', 'stg_dim_dates') }}

ORDER BY "date_id"
