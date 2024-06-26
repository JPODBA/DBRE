from pymongo import MongoClient
from pprint import pprint

client = MongoClient("mongodb://dba:Mtbr1241@172.16.0.62:37022")

def listDatabases():
    names = client.list_database_names()
    return names

db_list = listDatabases()

rmv_db = ['BA_DBA', 'admin', 'config', 'local']
for db in rmv_db:
    if db in db_list:
        db_list.remove(db)

# Abre um arquivo para escrever os logs
with open('logs_lentos.txt', 'w') as file:
    for db in db_list:
        db_log = client[db]
        logs_lentos = db_log.system.profile.find({"millis": {"$gt": 10}})
      
        descompacta_query = list(logs_lentos)  
        for log in descompacta_query:
            file.write(f"{log}\n")

def ler_logs_arquivo(file_path):
    with open(file_path, 'r') as file:
        logs = file.readlines()
    return logs

def analisar_consultas_lentas(logs_lentos):
    consultas_problema = []
    for log in logs_lentos:
        if "planSummary" in log and "COLLSCAN" in log["planSummary"]:
            consultas_problema.append(log)
    return consultas_problema

file_path = 'logs_lentos.txt'
logs_lidos = ler_logs_arquivo(file_path)
consultas_problema = analisar_consultas_lentas(logs_lidos)    

for log in consultas_problema:
    pprint(log)
