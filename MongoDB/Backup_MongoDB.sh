#!/bin/bash
# define the following in your env

mkdir /backup/dump/

echo 'DEBUG -- > Criou a Pasta bkp'

DEBUG=1
MONGO_USERNAME='backup'
MONGO_PASSWORD='PrecisaAlterar'
MONGO_AUTH_DB='admin'


MONGOPORT=$(cat /etc/mongod.conf | grep -i port: | cut -f2 -d":"| tr -d ' ')
DIRECTORY=$(hostname)
IP=$(hostname -i | cut -f1 -d" ") ## hostname -I (Maiusculo também retorna só o IP)
DATA=$(date +%Y-%m-%d)
BACKUP_NAME="$DIRECTORY"_"$DATA"

URI="mongodb://"$IP":"$MONGOPORT""

mkdir /backup/dump/$BACKUP_NAME

if echo "$DIRECTORY" | egrep 'WE'
then
  echo 'Entrou na String WE'
  AZURE_BLOB_CONTAINER='PrecisaAlterar'
  AZURE_DESTINATION_KEY='PrecisaAlterar'
  CONECTION_STRING='PrecisaAlterar'
else
  echo 'Entrou na String PRD'
  AZURE_BLOB_CONTAINER='PrecisaAlterar'
  AZURE_DESTINATION_KEY='PrecisaAlterar'
  CONECTION_STRING='PrecisaAlterar'
fi


if [ -z "$MONGOPORT" ]; then
  echo "Error: Você precisa set MONGOPORT @"
  exit 1
fi

if [ $DEBUG -eq 1 ]; then
  echo 'Debug variáveis: ' $DEBUG, $MONGO_USERNAME, $MONGO_PASSWORD, $MONGO_AUTH_DB, $MONGOPORT, $IP, $DIRECTORY, $DATA, $BACKUP_NAME
  echo 'URI @: ' $URI
  echo 'Debug variáveis de String Conexão: ' $AZURE_BLOB_CONTAINER,  $AZURE_DESTINATION_KEY, $CONECTION_STRING
fi

echo "Bkp iniciando ----------------------------------------------------------------------------------------------------------------------"

dbs=$(mongosh -u $MONGO_USERNAME -p $MONGO_PASSWORD $URI/admin --quiet --eval 'db.getMongo().getDBNames()' | grep "'" | tr -d "',")

for item in ${dbs[@]}; do
mongodump --authenticationDatabase admin -u $MONGO_USERNAME -p $MONGO_PASSWORD --uri $URI --db "$item" --out /backup/dump/$BACKUP_NAME/"$item"
done;


echo 'BKP FEITOOOO ------------------------------------------------------------------------------------------------------------------------'


echo 'Iniciando Upload --------------------------------------------------------------------------------------------------------------------'

az storage blob upload-batch --destination $AZURE_BLOB_CONTAINER --source /backup/dump/ --connection-string $CONECTION_STRING --account-key $AZURE_DESTINATION_KEY

echo 'Upload Finalizado --------------------------------------------------------------------------------------------------------------------'

echo "DEBUG -- >  Limpando disco"

rm -r /backup/dump/
exit 1

# crontab -e (Para agendar os eventos no linux)
# 00 23 * * * /data/Backup_MongoDB.sh
# chmod 600 Backup_MongoDB.sh
# chmod +x Backup_MongoDB.sh
#mongodump -u dba -p 'Mtbr1241' --uri "mongodb://172.16.0.40:37018" --out /data/dump/ --gzip


