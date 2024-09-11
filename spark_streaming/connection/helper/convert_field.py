from pyspark.sql.functions import col
from pyspark.sql.types import IntegerType, StringType, DoubleType

def convert_field_fact_customer_interaction(df):
    return df.select(
        col("interaction_id").cast(IntegerType()).alias("interaction_id"),
        col("date_id").cast(IntegerType()).alias("date_id"),
        col("channel_id").cast(IntegerType()).alias("channel_id"),
        col("location_id").cast(IntegerType()).alias("location_id"),
        col("customer_id").cast(IntegerType()).alias("customer_id"),
        col("interaction_type").alias("interaction_type"),
        col("interaction_rating").cast(IntegerType()).alias("interaction_rating")
    )


def convert_field_fact_daily_balance(df):
    return df.select(
        col("balance_id").cast(IntegerType()).alias("balance_id"),
        col("date_id").cast(IntegerType()).alias("date_id"),
        col("account_id").cast(IntegerType()).alias("account_id"),
        col("currency_id").cast(IntegerType()).alias("currency_id"),
        col("opening_balance").cast(DoubleType()).alias("opening_balance"),
        col("closing_balance").cast(DoubleType()).alias("closing_balance"),
        col("average_balance").cast(DoubleType()).alias("average_balance")
    )


def convert_field_fact_investment(df):
    return df.select(
        col("investment_id").cast(IntegerType()).alias("investment_id"),
        col("date_id").cast(IntegerType()).alias("date_id"),
        col("investment_type").cast(IntegerType()).alias("investment_type"),
        col("account_id").cast(IntegerType()).alias("account_id"),
        col("amount_invested").cast(DoubleType()).alias("amount_invested"),
        col("investment_return").cast(DoubleType()).alias("investment_return")
    )


def convert_field_fact_loan_payment(df):
    return df.select(
        col("payment_id").cast(IntegerType()).alias("payment_id"),
        col("date_id").cast(IntegerType()).alias("date_id"),
        col("loan_id").cast(IntegerType()).alias("loan_id"),
        col("customer_id").cast(IntegerType()).alias("customer_id"),
        col("payment_amount").cast(DoubleType()).alias("payment_amount"),
        col("payment_status").alias("payment_status")  
    )


def convert_field_fact_transaction(df):
    return df.select(
        col("transaction_id").cast(IntegerType()).alias("transaction_id"),
        col("customer_id").cast(IntegerType()).alias("customer_id"),
        col("txn_date_id").cast(IntegerType()).alias("txn_date_id"),
        col("channel_id").cast(IntegerType()).alias("channel_id"),
        col("account_id").cast(IntegerType()).alias("account_id"),
        col("txn_type_id").cast(IntegerType()).alias("txn_type_id"),
        col("location_id").cast(IntegerType()).alias("location_id"),
        col("currency_id").cast(IntegerType()).alias("currency_id"),
        col("loan_id").cast(IntegerType()).alias("loan_id"),
        col("investment_type_id").cast(IntegerType()).alias("investment_type_id"),
        col("txn_amount").cast(DoubleType()).alias("txn_amount"),
        col("txn_status").alias("txn_status")
    )