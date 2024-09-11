use role accountadmin;

create warehouse if not exists dbt_bank_warehouse with warehouse_size='x-small';
create database if not exists dbt_bank_db;
create role if not exists dbt_bank_role;

show grants on warehouse dbt_bank_warehouse;

grant usage on warehouse dbt_bank_warehouse to role dbt_bank_role;
grant role dbt_bank_role to user thangmaster2003;
grant all on database dbt_bank_db to role dbt_bank_role;

use role dbt_bank_role;

create schema if not exists dbt_bank_db.raw_bank_schema;
create schema if not exists dbt_bank_db.staging_bank_schema;
create schema if not exists dbt_bank_db.intermediate_bank_schema;
create schema if not exists dbt_bank_db.marts_bank_schema;

