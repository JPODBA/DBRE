## Redis 
## Instalando Redis
sudo apt install lsb-release

## Validar a versão antes de executar 
curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list

sudo apt-get update
sudo apt-get install redis


## Validando serviço on
sudo systemctl status redis-server.service

## Validando arquivo de configuração 
sudo vim /etc/sysctl.d/ 
sudo vim /etc/redis/redis.conf


## redis-cli conecta local 
redis-cli 

# iev!ucm77zmQM!<4Ll57
## Trás as informações do Server
info 

###
sudo apt install lsb-release

curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/redis.list

sudo apt-get update

sudo apt-get install redis


--- Removendo --- 

sudo systemctl stop redis-server

sudo apt-get remove --purge redis-server
sudo apt-get purge redis-server

sudo apt-get autoremove