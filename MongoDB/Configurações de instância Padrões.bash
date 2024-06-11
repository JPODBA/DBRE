## Configurações Padrões 
## Necessário ser padrão xfs de Disco. 
## Configuração de Host name e IP
VM-MONGO-PRD-NUMEROVM.internal.cloudapp.net - IP - porta:27040


sudo apt update
sudo apt upgrade -y

reboot

# Importanto a Chave publica - Valir a versão mais recente
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -


sudo apt-get install gnupg

echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list

sudo apt update

# Esse comando vai gerar um erro. E: Unable to correct problems, you have held broken packages.
sudo apt install -y mongodb-org

# Para instalar os pacotes. # Sempre buscar a versão mais recente do mongodb e do Linux em si. 
curl -LO http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1-1ubuntu2.1~18.04.20_amd64.deb
sudo dpkg -i ./libssl1.1_1.1.1-1ubuntu2.1~18.04.20_amd64.deb

## SUSE 
sudo zypper addrepo --gpgcheck "https://repo.mongodb.org/zypper/suse/15/mongodb-org/6.0/x86_64/" mongodb
sudo rpm --import https://www.mongodb.org/static/pgp/server-6.0.asc
zypper ref
sudo zypper -n install mongodb-org


# Repetimos o comando depois de baixar o Pacote. 
sudo apt install mongodb-org

sudo systemctl enable mongod

# dando permissão para alterar o path!!
sudo chown -R mongodb:mongodb /data/db
#adrão   - /var/lib/mongodb
#ovoPath - /data/db

sudo systemctl start mongod
sudo systemctl status mongod

sudo nano /etc/mongod.conf



## Arquivo Padrão exemplo. 

storage:
dbPath: /data/db
journal:
enabled: true
#  engine:
wiredTiger:
 engineConfig:
   cacheSizeGB: 2


# how the process runs
processManagement:
timeZoneInfo: /usr/share/zoneinfo

# network interfaces
net:
port: 37023
bindIp: 127.0.0.1, 172.16.0.55, VM-MONGO-PRD-06.internal.cloudapp.net # Enter 0.0.0.0,:: to bind to all IPv4 and IPv6 addresses or, alternati>

security:
	authorization: "enabled"


## Acessando MongoDB 
mongosh --port 37023 

