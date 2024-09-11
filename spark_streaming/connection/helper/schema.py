from pyspark.sql.types import StringType # Các kiểu dữ liệu
from pyspark.sql.types import StructField, StructType

schema_fact_customer_interaction = StructType([
    StructField('interaction_id', StringType(), nullable=True),
    StructField('date_id', StringType(), nullable=True),
    StructField('channel_id', StringType(), nullable=True),
    StructField('location_id', StringType(), nullable=True),
    StructField('customer_id', StringType(), nullable=True),
    StructField('interaction_type', StringType(), nullable=True),
    StructField('interaction_rating', StringType(), nullable=True)
])

schema_fact_daily_balance = StructType([
    StructField('balance_id', StringType(), nullable=True),
    StructField('date_id', StringType(), nullable=True),
    StructField('account_id', StringType(), nullable=True),
    StructField('currency_id', StringType(), nullable=True),
    StructField('opening_balance', StringType(), nullable=True),
    StructField('closing_balance', StringType(), nullable=True),
    StructField('average_balance', StringType(), nullable=True)
])

schema_fact_investment = StructType([
    StructField('investment_id', StringType(), nullable=True),
    StructField('date_id', StringType(), nullable=True),
    StructField('investment_type', StringType(), nullable=True),
    StructField('account_id', StringType(), nullable=True),
    StructField('amount_invested', StringType(), nullable=True),
    StructField('investment_return', StringType(), nullable=True)
])

schema_fact_loan_payment = StructType([
    StructField('payment_id', StringType(), nullable=True),
    StructField('date_id', StringType(), nullable=True),
    StructField('loan_id', StringType(), nullable=True),
    StructField('customer_id', StringType(), nullable=True),
    StructField('payment_amount', StringType(), nullable=True),
    StructField('payment_status', StringType(), nullable=True)
])

schema_fact_transaction = StructType([
    StructField('transaction_id', StringType(), nullable=True),
    StructField('customer_id', StringType(), nullable=True),
    StructField('txn_date_id', StringType(), nullable=True),
    StructField('channel_id', StringType(), nullable=True),
    StructField('account_id', StringType(), nullable=True),
    StructField('txn_type_id', StringType(), nullable=True),
    StructField('location_id', StringType(), nullable=True),
    StructField('currency_id', StringType(), nullable=True),
    StructField('loan_id', StringType(), nullable=True),
    StructField('investment_type_id', StringType(), nullable=True),
    StructField('txn_amount', StringType(), nullable=True),
    StructField('txn_status', StringType(), nullable=True)
])


