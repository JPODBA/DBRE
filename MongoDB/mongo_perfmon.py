# pip install pymongo psutil

import psutil
import time
from pymongo import MongoClient
from pymongo.errors import ConnectionFailure

# Configurações
MONGO_URI = "mongodb://localhost:27017"
DATABASE_NAME = "meu_banco_de_dados"
CPU_THRESHOLD = 80.0  # Limiar de uso de CPU em %
MEM_THRESHOLD = 80.0  # Limiar de uso de memória em %
QUERY_TIME_THRESHOLD = 100  # Tempo de consulta em ms

def connect_to_mongo(uri):
    try:
        client = MongoClient(uri)
        client.admin.command('ping')
        print("Conectado ao MongoDB")
        return client
    except ConnectionFailure:
        print("Falha ao conectar ao MongoDB")
        return None

def get_db_stats(client, db_name):
    db = client[db_name]
    stats = db.command("dbstats")
    return stats

def monitor_system_resources():
    cpu_usage = psutil.cpu_percent(interval=1)
    mem_usage = psutil.virtual_memory().percent
    return cpu_usage, mem_usage

def monitor_query_performance(client, db_name):
    db = client[db_name]
    start_time = time.time()
    db.collection_names()  # Executando uma consulta simples para exemplo
    end_time = time.time()
    query_time = (end_time - start_time) * 1000  # Convertendo para ms
    return query_time

def check_anomalies(cpu_usage, mem_usage, query_time):
    anomalies = []
    if cpu_usage > CPU_THRESHOLD:
        anomalies.append(f"Alto uso de CPU detectado: {cpu_usage}%")
    if mem_usage > MEM_THRESHOLD:
        anomalies.append(f"Alto uso de memória detectado: {mem_usage}%")
    if query_time > QUERY_TIME_THRESHOLD:
        anomalies.append(f"Tempo de consulta alto detectado: {query_time} ms")
    return anomalies

def main():
    client = connect_to_mongo(MONGO_URI)
    if not client:
        return
    
    while True:
        cpu_usage, mem_usage = monitor_system_resources()
        query_time = monitor_query_performance(client, DATABASE_NAME)
        anomalies = check_anomalies(cpu_usage, mem_usage, query_time)

        if anomalies:
            for anomaly in anomalies:
                print(f"[ALERTA] {anomaly}")

        # Esperar um pouco antes da próxima verificação
        time.sleep(10)

if __name__ == "__main__":
    main()
