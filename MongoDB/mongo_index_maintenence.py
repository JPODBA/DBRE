from pymongo import MongoClient

def reindex_collection(db, collection_name):
    if "system." in collection_name:
        print(f"Skipping system collection: {collection_name}")
        return
    result = db.command('reIndex', collection_name)
    print(f"Reindex result for {collection_name}: {result}")


def reindex_all_collections(uri):
    
    client = MongoClient(uri)
    try:
        databases = client.list_database_names()
        for dbname in databases:
            if dbname not in ["admin", "local","config", "BA_DBA"]:  # Para evitar BUGs e onde não precisa
                db = client[dbname]
                collection_names = db.list_collection_names()
                for collection_name in collection_names:
                    reindex_collection(db, collection_name)
    finally:
        client.close()

if __name__ == "__main__":
    uri = "mongodb://dba:Mtbr1241@172.19.0.10:39017"
    reindex_all_collections(uri)


