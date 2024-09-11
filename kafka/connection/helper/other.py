import json

# Hàm tuần tự hóa để chuyển đổi dữ liệu thành chuỗi JSON
def json_serializer(data):
    return json.dumps(data).encode('utf-8')