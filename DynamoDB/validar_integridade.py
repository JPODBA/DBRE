import boto3


dynamodb = boto3.client('dynamodb')

def check_table_status(table_name):
    response = dynamodb.describe_table(
        TableName=table_name
    )
    status = response['Table']['TableStatus']
    print(f"Status da tabela {table_name}: {status}")

check_table_status('tabela')
