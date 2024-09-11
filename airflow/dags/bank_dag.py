from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.empty import EmptyOperator

default_args = {
    'owner': 'bank-dbt', # Tên chủ sỡ hữu
    'depends_on_past': True, # True để xác định rằng các task hiện tại sẽ phụ thuộc vào các tast trước đó 
    'start_date' : datetime(2024, 9, 15, 0, 0, 0, 0), # Ngày bắt đầu thực thi luồng data
    # 'end_date' : datetime(2024, 8, 15, 0, 0, 0, 0),
    'email_on_failure': False, # False để xác định không có email thông báo khi thực thi bị lỗi
    'email_on_retry': False, # False xác định không có email thông báo được gửi khi task được thực hiện lại
    'retries': 1, # Số lần thử lại trước khi đánh dấu task thất bại
    'retry_delay': timedelta(minutes=0), # Khoảng thời gian giữa những lần thử lại task
    'trigger_rule': 'none_failed', # Xác định rằng task hiện tại chỉ được thực hiện khi các task trước đó không bị lỗi
    'catchup': True # Các task sẽ được chạy lại khi bị lỡ
}

dag_name = 'banking_pipeline_dbt'

with DAG(
    dag_id=dag_name,
    default_args=default_args,
    description="This data pipeline is built to push data from data lake to data warehouse with transform data by DBT",
    schedule_interval='5 0 * * *',
    max_active_runs=3
) as dag:
    
    # Bắt đầu thực thi task
    start_operations = EmptyOperator(task_id = 'Begin_execution')

    