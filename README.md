# Orbit Fullnode Synchronization Guide

A simple Docker script for launching full node for Orbit chains.

## Recommended Hardware
Please refer to https://docs.arbitrum.io/node-running/how-tos/running-an-orbit-node#prerequisites

## Preparation
1. Clone this repository
2. Obtain the `nodeConfigFullNodeExt.json` file for your chain

## Operating the Node

### Start
```sh
./start.sh
```
You should see something like:
```
Directory does not exist: /home/ubuntu/orbit-full-node/persistence
Creating...
Container for orbit-full-node does not exist
Creating...
dd04b00ff88cf323f5396491dfd7c95a92962a83ac450714134b3b0b130e9fb8
```

### View Logs
```sh
docker logs -f orbit-full-node
```

### Sanity Test
#### Check Sync Status
```sh
curl --location 'localhost:8547' \
--header 'Content-Type: application/json' \
--data '{
  "jsonrpc": "2.0",
  "method": "eth_syncing",
  "param": [],
  "id": 2
}'
```
If the node is still syncing, you should see something like:
```json
{
  "jsonrpc": "2.0",
  "id": 2,
  "result": {
    "batchProcessed": 927,
    "batchSeen": 927,
    "blockNum": 19086,
    "broadcasterQueuedMessagesPos": 0,
    "messageOfLastBlock": 19087,
    "messageOfProcessedBatch": 385836,
    "msgCount": 385837
  }
}
```
Or if the syncing has completed:
```json
{"jsonrpc":"2.0","id":2,"result":false}
```

#### Check After Syncing
```sh
curl --location 'localhost:8545' \
--header 'Content-Type: application/json' \
--data '{
  "jsonrpc": "2.0",
  "method": "eth_blockNumber",
  "id": 2
}'
```
This should return something like:
```sh
{
    "jsonrpc": "2.0",
    "id": 2,
    "result": "0x2139"
}
```

### Stop
```sh
./stop.sh
```
Note that stopping the node will not remove the `persistence` folder.