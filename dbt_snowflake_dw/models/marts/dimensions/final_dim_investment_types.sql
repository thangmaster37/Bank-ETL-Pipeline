-- models/marts/dimensions/final_dim_investment_types.sql

{{
    config(
        materialized='incremental',
        alias='final_dim_investment_types',
        unique_key='investment_type_id',
        incremental_strategy='merge'
    )
}}

SELECT 
    "investment_type_id",
    "investment_type_name"

FROM 
    {{ source('staging_snowflake', 'stg_dim_investment_types') }}

ORDER BY "investment_type_id"
