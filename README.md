# Orbit Fullnode Synchronization Guide

A simple Docker script for launching full node for Orbit chains.

## Recommended Hardware
Please refer to https://docs.arbitrum.io/node-running/how-tos/running-an-orbit-node#prerequisites

## Preparation
1. Clone this repository
2. Obtain the `nodeConfigFullNodeExt.json` file for your chain
3. Fill up the following values in `variables.sh`:
   - `RPC_URL`
      - This is the RPC URL for your settlement chain (e.g., Arbitrum Sepolia)
      - You can obtain an Arbitrum chain endpoint from the list here: https://docs.arbitrum.io/build-decentralized-apps/reference/node-providers
      - For other chain endpoints (e.g., Ethereum Sepolia) you can obtain an endpoint from https://chainlist.org/

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

### Known Issue

#### Unable to find validator machine directory for the on-chain WASM module root

Github Issue link: https://github.com/OffchainLabs/nitro/issues/2567.

Solution: Add the `--validation.wasm.enable-wasmroots-check=false` to the argument of `docker run command` in the [start.sh](./start.sh). For example:

```sh
  docker run \
    ...
      --conf.file=/data/config/nodeConfig.json \
      --parent-chain.connection.url=$RPC_URL \
      --node.dangerous.disable-blob-reader \
      --validation.wasm.enable-wasmroots-check=false
```
More information about this:

- `--validation.wasm.allowed-wasm-module-roots strings`: list of WASM module roots or machine base paths to match against on-chain WasmModuleRoot
- `--validation.wasm.enable-wasmroots-check`: enable check for compatibility of on-chain WASM module root with node (default true)
- `--validation.wasm.root-path string`: path to machine folders, each containing wasm files (machine.wavm.br, replay.wasm)