{{
    config(
        materialized='incremental',
        alias='stg_dim_investment_types',
        schema=var('staging_bank_schema'),
        unique_key='investment_type_id',
        incremental_strategy='delete+insert'
    )
}}

SELECT
    investment_type_id,
    investment_type_name

FROM 
    {{ source('staging_snowflake', 'dim_investment_types')}}