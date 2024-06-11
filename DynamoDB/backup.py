import boto3
from datetime import datetime


dynamodb = boto3.client('dynamodb')

def create_backup(tabela):
    backup_name = f"{tabela}-backup-{datetime.now().strftime('%Y-%m-%d-%H-%M-%S')}"
    response = dynamodb.create_backup(
        TableName=tabela,
        BackupName=backup_name
    )
    print(f"Backup criado: {response['BackupDetails']['BackupArn']}")

create_backup('Tabela_teste')
