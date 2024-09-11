{{
    config(
        materialized='incremental',
        alias='stg_dim_transaction_types',
        schema=var('staging_bank_schema'),
        unique_key='transaction_type_id',
        incremental_strategy='delete+insert'
    )
}}

SELECT
    transaction_type_id,
    transaction_type_name

FROM 
    {{ source('staging_snowflake', 'dim_transaction_types')}}