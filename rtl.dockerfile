FROM shahanafarooqui/rtl:0.13.2@sha256:07d4c1f263c05c32270dcaab3625fc68ef985efce652e7850fbf57f65d36366f


ENV PORT=3000 \
    APP_PASSWORD=freedomtech \
    LN_IMPLEMENTATION=CLN \
    LN_SERVER_URL=http://core-lightning:3003/v1 \
    MACAROON_PATH=/root/.lightning/certs \
    RTL_CONFIG_PATH=/root/.lightning/rtl \
    RTL_COOKIE_PATH=/root/.lightning/rtl/.cookie \
    LIGHTNINGD_NETWORK=testnet