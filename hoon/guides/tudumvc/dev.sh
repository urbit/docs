#!/bin/bash
if [ -z "$1" ]
then
    echo "usage: dev.sh URBIT_PIER_HOME_DIRECTORY"
    exit;
fi

while [ 0 ]
do
sleep  0.1
rsync -ru --exclude '.*' app $1
rsync -ru --exclude '.*' sur $1
rsync -ru --exclude '.*' mar $1
rsync -ru --exclude '.*' gen $1
rsync -ru --exclude '.*' lib $1
done
