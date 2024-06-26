from pymongo import MongoClient

client = MongoClient("mongodb://dba:Mtbr1241@172.16.0.40:37018")
def listDatabases():
    names = client.list_database_names()
    return names
db_list = listDatabases()
print(db_list)
rmv_db = ['BA_DBA','admin', 'config', 'local']
for db in db_list:
    if db in rmv_db:
        db_list.remove(db)

print(db_list)
