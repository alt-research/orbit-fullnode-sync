#!/bin/bash
source variables.sh

docker stop $FN_CONTAINER_NAME
docker container rm $FN_CONTAINER_NAME

echo "Reminder to manually delete $(pwd)/$PERSISTENCE folder if you want to remove node's storage"
