-- models/marts/dimensions/final_dim_transaction_types.sql

{{
    config(
        materialized='incremental',
        alias='final_dim_transaction_types',
        unique_key='transaction_type_id',
        incremental_strategy='merge'
    )
}}

SELECT 
    "transaction_type_id",
    "transaction_type_name"

FROM 
    {{ source('staging_snowflake', 'stg_dim_transaction_types') }}

ORDER BY "transaction_type_id"
