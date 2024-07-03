# pip install pymongo
from pymongo import MongoClient
from pprint import pprint
import json
from bson import Binary, ObjectId
from datetime import datetime

client = MongoClient("mongodb://user:senha@172.19.0.10:39017")

def listDatabases():
    names = client.list_database_names('ploomescrm_2667')
    return names

db_list = listDatabases()

rmv_db = ['BA_DBA', 'admin', 'config', 'local']
for db in rmv_db:
    if db in db_list:
        db_list.remove(db)

def json_serial(obj):
    if isinstance(obj, (datetime,)):
        return obj.isoformat()
    elif isinstance(obj, (ObjectId,)):
        return str(obj)
    elif isinstance(obj, (Binary,)):
        return obj.hex()
    raise TypeError(f"Type {type(obj)} not serializable")

with open('logs_lentos.txt', 'w') as file:
    for db in db_list:
        db_log = client[db]
        logs_lentos = db_log.system.profile.find({"millis": {"$gt": 1000}})
      
        descompacta_query = list(logs_lentos)
        for log in descompacta_query:
            file.write(f"{json.dumps(log, default=json_serial)}\n")  

def ler_logs_arquivo(file_path):
    with open(file_path, 'r') as file:
        logs = [json.loads(line) for line in file]  # Converte cada linha de volta para um dicionário saporra
    return logs

def analisar_consultas_lentas(logs_lentos):
    consultas_problema = []
    for log in logs_lentos:
        if "planSummary" in log and "COLLSCAN" in log["planSummary"]:
            consultas_problema.append(log)
    return consultas_problema

file_path = 'logs_lentos.txt'
logs_lidos = ler_logs_arquivo(file_path)
# consultas_problema = analisar_consultas_lentas(logs_lidos)    
# print(consultas_problema) #DEBUG
for log in logs_lidos:
    print('####################################################################')
    pprint(log)
    print('####################################################################')
