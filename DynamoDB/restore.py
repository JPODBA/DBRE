import boto3


dynamodb = boto3.client('dynamodb')

def restore_table_from_backup(path_bkp, Tabele_Bkp):
    response = dynamodb.restore_table_from_backup(
        TargetTableName=Tabele_Bkp,
        BackupArn=path_bkp
    )
    print(f"Tabela restaurada: {response['TableDescription']['TableArn']}")

# Substitua pelo ARN do backup e o nome da tabela de destino
restore_table_from_backup('arn:aws:dynamodb:us-east-1:123456789012:table/Usuarios-backup-2024-06-11-10-30-00', 'UsuariosRestaurada')
