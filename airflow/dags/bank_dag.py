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

    # Đẩy dữ liệu từ các file trong seeds lên snowflake
    raw_data = BashOperator(
        task_id = "push_data_to_raw",
        bash_command = "cd /dbt && dbt seed"
    )

    # Lấy dữ liệu từ raw_data để xử lý và lưu vào staging schema
    staging_data = BashOperator(
        task_id = "push_data_to_staging",
        bash_command = "cd /dbt && dbt run --profiles-dir . --target staging --models staging"
    )

    # Lấy dữ liệu từ staging schema thực hiện một vài chuyển đổi khác để làm dữ liệu rõ ràng hơn 
    # phục vụ cho việc phần tích và lưu vào marts schema
    final_data = BashOperator(
        task_id = "push_data_to_marts",
        bash_command = "cd /dbt && dbt run --profiles-dir . --target final --models marts"
    )

    # Thực hiện kiểm tra tính toàn vẹn của dữ liệu trong staging schema
    test_data_staging = BashOperator(
        task_id = "test_data_schema_staging",
        bash_command = "cd /dbt && dbt test --profiles-dir . --target staging --models staging"
    )

    # Thực hiện kiểm tra tính toàn vẹn của dữ liệu trong marts schema
    test_data_final = BashOperator(
        task_id = "test_data_marts",
        bash_command = "cd /dbt && dbt test --profiles-dir . --target final --models marts"
    )

    # Kết thúc thực thi task
    end_operations = EmptyOperator(task_id = 'End_execution')

    # Luồng thực thi các task
    start_operations >> \
    raw_data >> \
    staging_data >> \
    final_data >> \
    test_data_staging >> \
    test_data_final >> \
    end_operations