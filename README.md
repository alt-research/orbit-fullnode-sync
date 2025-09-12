# Orbit Fullnode Synchronization Guide

A simple Docker script for launching fullnode for Orbit chains.

## Recommended Hardware
Please refer to https://docs.arbitrum.io/node-running/how-tos/running-an-orbit-node#prerequisites

## Preparation

> [!NOTE]
  > For steps 2 and 3, please contact AltLayer team directly for the location of the latest files for your chain.

1. Clone this repository
2. Obtain the `nodeConfigFullNodeExt.json` file for your chain and place in your clone directory
3. Obtain the latest available snapshot for your chain and extract into your clone directory
   - Your clone directory should now contain a `persistence` folder, with all chain data stored in `persistence/<chain name>`
4. Fill up `RPC_URL` in `variables.sh`
   - This is the RPC URL for your settlement chain (e.g., Arbitrum Sepolia)
   - You can consider publicly available endpoints (e.g., [here](https://docs.arbitrum.io/build-decentralized-apps/reference/node-providers)), but it's recommended to source one with higher rate limits to avoid any issues
5. If necessary, customize the other parameters in `variables.sh`
   - `DOCKER_TAG`: The latest supported version by your Orbit chain
   - `PORT_RPC`: HTTP-RPC server listening port
   - `PORT_WS`: WS-RPC server listening port
   - `EXTRA_OPTS`: Any additional nitro parameters

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
curl --location 'localhost:8547' \
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

## References
- https://docs.arbitrum.io/run-arbitrum-node/run-full-node
- https://github.com/OffchainLabs/nitro