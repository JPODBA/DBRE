from pymongo import MongoClient
from pymongo.errors import ConnectionFailure

def conectar_mongodb(uri):
    try:
        client = MongoClient(uri)
        # Verifica a conexão
        client.admin.command('ping')
        print("Conexão com MongoDB bem-sucedida")
        return client
    except ConnectionFailure:
        print("Falha na conexão com MongoDB")
        return None

def obter_logs_lentos(client, database_name):
    db = client[database_name]
    logs_lentos = db.system.profile.find({"millis": {"$gt": 100}})  

def analisar_consultas_lentas(logs_lentos):
    consultas_problema = []
    for log in logs_lentos:
        if "planSummary" in log and "COLLSCAN" in log["planSummary"]:
            consultas_problema.append(log)
    return consultas_problema

def main():
    uri = "mongodb://dba:Mtbr1241@172.16.0.40:37018"  
    client = conectar_mongodb(uri)
    if client:        
        tenants = client.list_database_names()
        for tenant_db in tenants:
            # print(tenant_db, ' ', obter_logs_lentos(client, tenant_db))
            logs_lentos = obter_logs_lentos(client, tenant_db)
            consultas_problema = analisar_consultas_lentas(logs_lentos)            
            if consultas_problema:
                print(f"Consultas lentas identificadas no banco de dados do tenant {tenant_db}:")
                for consulta in consultas_problema:
                    print(consulta)

if __name__ == "__main__":
    main()

