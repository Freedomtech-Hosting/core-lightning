FROM ghcr.io/elementsproject/cln-application:0.0.3@sha256:05595731a98a17aff6603b9ad35aaa17825bf1e51dd22da409c37f9fce5d2b2e

ENV APP_CORE_LIGHTNING_IP=0.0.0.0 \
    APP_CORE_LIGHTNING_PORT=2103 \
    APP_CORE_LIGHTNING_DAEMON_IP=172.18.0.6 \
    APP_CORE_LIGHTNING_WEBSOCKET_PORT=2106 \
    APP_CONFIG_DIR=/data/core-lightning-application \
    CORE_LIGHTNING_PATH=/data \
    APP_CORE_LIGHTNING_BITCOIN_NETWORK=testnet \
    COMMANDO_CONFIG=/tmp/.commando


CMD [ "npm", "run", "start" ]