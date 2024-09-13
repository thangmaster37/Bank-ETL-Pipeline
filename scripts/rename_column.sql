-- Thay đổi tên các cột của bảng fact_customer_interactions thành chữ thường
ALTER TABLE raw_bank_schema.fact_customer_interactions RENAME COLUMN "INTERACTION_ID" TO "interaction_id";
ALTER TABLE raw_bank_schema.fact_customer_interactions RENAME COLUMN "DATE_ID" TO "date_id";
ALTER TABLE raw_bank_schema.fact_customer_interactions RENAME COLUMN "CHANNEL_ID" TO "channel_id";
ALTER TABLE raw_bank_schema.fact_customer_interactions RENAME COLUMN "LOCATION_ID" TO "location_id";
ALTER TABLE raw_bank_schema.fact_customer_interactions RENAME COLUMN "CUSTOMER_ID" TO "customer_id";
ALTER TABLE raw_bank_schema.fact_customer_interactions RENAME COLUMN "INTERACTION_TYPE" TO "interaction_type";
ALTER TABLE raw_bank_schema.fact_customer_interactions RENAME COLUMN "INTERACTION_RATING" TO "interaction_rating";


-- Thay đổi tên các cột của bảng fact_daily_balances thành chữ thường
ALTER TABLE raw_bank_schema.fact_daily_balances RENAME COLUMN "BALANCE_ID" TO "balance_id";
ALTER TABLE raw_bank_schema.fact_daily_balances RENAME COLUMN "DATE_ID" TO "date_id";
ALTER TABLE raw_bank_schema.fact_daily_balances RENAME COLUMN "ACCOUNT_ID" TO "account_id";
ALTER TABLE raw_bank_schema.fact_daily_balances RENAME COLUMN "CURRENCY_ID" TO "currency_id";
ALTER TABLE raw_bank_schema.fact_daily_balances RENAME COLUMN "OPENING_BALANCE" TO "opening_balance";
ALTER TABLE raw_bank_schema.fact_daily_balances RENAME COLUMN "CLOSING_BALANCE" TO "closing_balance";
ALTER TABLE raw_bank_schema.fact_daily_balances RENAME COLUMN "AVERAGE_BALANCE" TO "average_balance";


-- Thay đổi tên các cột của bảng fact_investments thành chữ thường
ALTER TABLE raw_bank_schema.fact_investments RENAME COLUMN "INVESTMENT_ID" TO "investment_id";
ALTER TABLE raw_bank_schema.fact_investments RENAME COLUMN "DATE_ID" TO "date_id";
ALTER TABLE raw_bank_schema.fact_investments RENAME COLUMN "INVESTMENT_TYPE" TO "investment_type";
ALTER TABLE raw_bank_schema.fact_investments RENAME COLUMN "ACCOUNT_ID" TO "account_id";
ALTER TABLE raw_bank_schema.fact_investments RENAME COLUMN "AMOUNT_INVESTED" TO "amount_invested";
ALTER TABLE raw_bank_schema.fact_investments RENAME COLUMN "INVESTMENT_RETURN" TO "investment_return";


-- Thay đổi tên các cột của bảng fact_loan_payments thành chữ thường
ALTER TABLE raw_bank_schema.fact_loan_payments RENAME COLUMN "PAYMENT_ID" TO "payment_id";
ALTER TABLE raw_bank_schema.fact_loan_payments RENAME COLUMN "DATE_ID" TO "date_id";
ALTER TABLE raw_bank_schema.fact_loan_payments RENAME COLUMN "LOAN_ID" TO "loan_id";
ALTER TABLE raw_bank_schema.fact_loan_payments RENAME COLUMN "CUSTOMER_ID" TO "customer_id";
ALTER TABLE raw_bank_schema.fact_loan_payments RENAME COLUMN "PAYMENT_AMOUNT" TO "payment_amount";
ALTER TABLE raw_bank_schema.fact_loan_payments RENAME COLUMN "PAYMENT_STATUS" TO "payment_status";


-- Thay đổi tên các cột của bảng fact_transactions thành chữ thường
ALTER TABLE raw_bank_schema.fact_transactions RENAME COLUMN "TRANSACTION_ID" TO "transaction_id";
ALTER TABLE raw_bank_schema.fact_transactions RENAME COLUMN "CUSTOMER_ID" TO "customer_id";
ALTER TABLE raw_bank_schema.fact_transactions RENAME COLUMN "TXN_DATE_ID" TO "txn_date_id";
ALTER TABLE raw_bank_schema.fact_transactions RENAME COLUMN "CHANNEL_ID" TO "channel_id";
ALTER TABLE raw_bank_schema.fact_transactions RENAME COLUMN "ACCOUNT_ID" TO "account_id";
ALTER TABLE raw_bank_schema.fact_transactions RENAME COLUMN "TXN_TYPE_ID" TO "txn_type_id";
ALTER TABLE raw_bank_schema.fact_transactions RENAME COLUMN "LOCATION_ID" TO "location_id";
ALTER TABLE raw_bank_schema.fact_transactions RENAME COLUMN "CURRENCY_ID" TO "currency_id";
ALTER TABLE raw_bank_schema.fact_transactions RENAME COLUMN "LOAN_ID" TO "loan_id";
ALTER TABLE raw_bank_schema.fact_transactions RENAME COLUMN "INVESTMENT_TYPE_ID" TO "investment_type_id";
ALTER TABLE raw_bank_schema.fact_transactions RENAME COLUMN "TXN_AMOUNT" TO "txn_amount";
ALTER TABLE raw_bank_schema.fact_transactions RENAME COLUMN "TXN_STATUS" TO "txn_status";
