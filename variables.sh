set -e
FN_CONTAINER_NAME=orbit-full-node
DOCKER_REPO=offchainlabs/nitro-node
DOCKER_TAG=v3.9.5-66e42c4
PORT_RPC=8547
PORT_WS=8548
PERSISTENCE=persistence
RPC_URL=
EXTRA_OPTS="--validation.wasm.allowed-wasm-module-roots=/home/user/nitro-legacy/machines --validation.wasm.root-path=/home/user/nitro-legacy/machines"
set +e
