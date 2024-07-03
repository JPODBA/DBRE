from pymongo import MongoClient

def reindex_all_collections(uri):
    client = MongoClient(uri)   
    databases = client.list_database_names()
    
    for db_name in databases:
        
        if db_name in ['admin', 'config', 'local']:
            continue
        
        db = client[db_name]
        
        collections = db.list_collection_names()
        
        for collection_name in collections:
            collection = db[collection_name]
            print(f"Reindexando coleção: {db_name}.{collection_name}")
            
            # Reindexa a coleção
            collection.reindex()
    
    print("Reindexação completa.")

if __name__ == "__main__":
    uri = "mongodb://localhost:27017"
    reindex_all_collections(uri)
