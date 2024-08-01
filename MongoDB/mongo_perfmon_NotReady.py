# pip install pymongo
import psutil # process and system utilities
import time
from pymongo import MongoClient
from pymongo.errors import ConnectionFailure


MONGO_URI = "mongodb://dba:Mtbr1241@172.16.0.40:37018"
CPU_THRESHOLD = 80.0  
MEM_THRESHOLD = 80.0  
QUERY_TIME_THRESHOLD = 100  

def connect_to_mongo(uri):
    try:
        client = MongoClient(uri)
        client.admin.command('ping')
        print("Conectado ao MongoDB")
        return client
    except ConnectionFailure:
        print("Falha ao conectar ao MongoDB")
        return None

def get_all_databases(client):
    return client.list_database_names()

def monitor_system_resources():
    cpu_usage = psutil.cpu_percent(interval=1)
    mem_usage = psutil.virtual_memory().percent
    return cpu_usage, mem_usage

def monitor_query_performance(db):
    start_time = time.time()
    db.list_collection_names()  
    end_time = time.time()
    query_time = (end_time - start_time) * 1000  ## Convertendo para ms
    return query_time

def check_anomalies(cpu_usage, mem_usage, query_time, db_name):
    anomalies = []
    if cpu_usage > CPU_THRESHOLD:
        anomalies.append(f"[{db_name}] Alto uso de CPU detectado: {cpu_usage}%")
    if mem_usage > MEM_THRESHOLD:
        anomalies.append(f"[{db_name}] Alto uso de memória detectado: {mem_usage}%")
    if query_time > QUERY_TIME_THRESHOLD:
        anomalies.append(f"[{db_name}] Tempo de consulta alto detectado: {query_time} ms")
    return anomalies

def main():
    client = connect_to_mongo(MONGO_URI)
    if not client:
        return
    
    while True:
        all_anomalies = []
        databases = get_all_databases(client)
        cpu_usage, mem_usage = monitor_system_resources()
        
        for db_name in databases:
            db = client[db_name]
            query_time = monitor_query_performance(db)
            anomalies = check_anomalies(cpu_usage, mem_usage, query_time, db_name)
            all_anomalies.extend(anomalies)

        if all_anomalies:
            for anomaly in all_anomalies:
                print(f"[ALERTA] {anomaly}")

       
        time.sleep(10)

if __name__ == "__main__":
    main()
