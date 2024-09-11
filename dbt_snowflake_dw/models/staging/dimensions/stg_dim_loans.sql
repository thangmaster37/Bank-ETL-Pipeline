{{
    config(
        materialized='incremental',
        alias='stg_dim_loans',
        schema=var('staging_bank_schema'),
        unique_key='loan_id',
        incremental_strategy='delete+insert'
    )
}}

SELECT
    loan_id,
    loan_type,
    loan_amount,
    interest_rate

FROM 
    {{ source('staging_snowflake', 'dim_loans')}}