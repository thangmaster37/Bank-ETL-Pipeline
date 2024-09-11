{{
    config(
        materialized='incremental',
        alias='stg_dim_currencies',
        schema=var('staging_bank_schema'),
        unique_key='currency_id',
        incremental_strategy='delete+insert'
    )
}}

SELECT
    currency_id,
    currency_code,
    currency_name

FROM 
    {{ source('staging_snowflake', 'dim_currencies')}}