import boto3
import datetime


cloudwatch = boto3.client('cloudwatch')

def get_table_metrics(table_name, metric_name, start_time, end_time, period):
    response = cloudwatch.get_metric_statistics(
        Namespace='AWS/DynamoDB',
        MetricName=metric_name,
        Dimensions=[
            {
                'Name': 'TableName',
                'Value': table_name
            }
        ],
        StartTime=start_time,
        EndTime=end_time,
        Period=period,
        Statistics=['Sum']
    )
    for data_point in response['Datapoints']:
        print(f"Timestamp: {data_point['Timestamp']}, {metric_name}: {data_point['Sum']}")

start_time = datetime.datetime.utcnow() - datetime.timedelta(minutes=60)
end_time = datetime.datetime.utcnow()
period = 300  # 5 minutos

# Exemplo de monitoramento de ConsumedReadCapacityUnits
get_table_metrics('Usuarios', 'ConsumedReadCapacityUnits', start_time, end_time, period)


