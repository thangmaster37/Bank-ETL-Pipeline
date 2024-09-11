{{
    config(
        materialized='incremental',
        alias='stg_dim_dates',
        schema=var('staging_bank_schema'),
        unique_key='date_id',
        incremental_strategy='delete+insert'
    )
}}

SELECT
    date_id,
    "date",
    "day",
    "month",
    "year",
    "quarter",
    "weekday"

FROM 
    {{ source('staging_snowflake', 'dim_dates')}}