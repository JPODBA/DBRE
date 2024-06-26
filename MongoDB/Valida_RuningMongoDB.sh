#! /bin/bash
if pgrep mongod > /dev/null; then
    echo "Mongo está em execução"
else
    echo "Mongo não está UP. Startando novamente MongoDB..."
    sudo systemctl start mongod
fi
