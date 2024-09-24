#!/bin/bash
source variables.sh

if [ -d $PERSISTENCE ]; then
  echo "Directory exists: $(pwd)/$PERSISTENCE"
else
  echo "Directory does not exist: $(pwd)/$PERSISTENCE"
  echo "Creating..."
  mkdir $PERSISTENCE
fi

CONTAINER_ID=$(docker container ls -f name=$FN_CONTAINER_NAME --all -q)
if [ -z $CONTAINER_ID ]; then
  echo "Container for $FN_CONTAINER_NAME does not exist"
  echo "Creating..."
  docker run \
    --detach \
    --restart always \
    --name $FN_CONTAINER_NAME \
    --entrypoint /usr/local/bin/nitro \
    --volume $(pwd)/$PERSISTENCE:/data \
    --volume $(pwd)/nodeConfigFullNodeExt.json:/data/config/nodeConfig.json \
    --publish $PORT_RPC:$PORT_RPC \
    --publish $PORT_WS:$PORT_WS \
    $DOCKER_REPO:$DOCKER_TAG \
      --conf.file=/data/config/nodeConfig.json \
      --parent-chain.connection.url=$RPC_URL \
      --node.dangerous.disable-blob-reader \
      --validation.wasm.enable-wasmroots-check=false
else
  echo "Container for $FN_CONTAINER_NAME exists: $CONTAINER_ID"
  echo "Restarting..."
  docker start $CONTAINER_ID
fi
