# Padrão de User

db.createUser(
 {
user: "zabbix",
pwd: "qjpFfMznTYr8WQPJ",
 roles: [
		{ role: 'userAdminAnyDatabase', db: 'admin' },
		{ role: 'readWriteAnyDatabase', db: 'admin' },
        { role: 'clusterAdmin', db: 'admin' },
  ]
 }
 
 
db.createUser({ user: "backup", pwd: "P1YSKKnKLW2O6Id9U5dZ",  roles: [{ role: 'backup', db: "admin"}, { role: 'restore', db: "admin"} ]} )
 
 
# Para ter as permissões necessárias para o Desv operar por conta. 
db.createUser({
user: "AlteraUser",
pwd: "AlteraSenha",
 roles: [ 	
		  { role: 'dbOwner', db: 'DistributedLock' },
          { role: 'dbOwner', db: 'ploomes-accountmodels-prd' },
          { role: 'userAdminAnyDatabase', db: 'admin' },
          { role: 'readWriteAnyDatabase', db: 'admin' },
          { role: 'clusterAdmin', db: 'admin' }
		]
 }
 )
 
# Alterando Senha
db.changeUserPassword('ploomes', 'NovaSenha')
 
# Dropar um user
use admin
db.dropUser("AlteraUser", {w: "majority", wtimeout: 5000})