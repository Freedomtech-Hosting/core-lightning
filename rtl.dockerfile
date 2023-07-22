FROM shahanafarooqui/rtl:0.14.0

# create default config. RTL wants to create it by itself but fails because we are running inside a docker container
# with a user without a home directory. So creating one ourselves fixes that issue
RUN echo '{"port":"3000","defaultNodeIndex":1,"SSO":{"rtlSSO":0,"rtlCookiePath":"","logoutRedirectLink":""},"nodes":[{"index":1,"lnNode":"Node 1","lnImplementation":"LND","Authentication":{"macaroonPath":"/root/.lnd/data/chain/bitcoin/mainnet","configPath":"/root/.lnd/lnd.conf"},"Settings":{"userPersona":"OPERATOR","themeMode":"NIGHT","themeColor":"PURPLE","channelBackupPath":"/tmp/backup","logLevel":"ERROR","lnServerUrl":"https://localhost:8080","fiatConversion":false,"unannouncedChannels":false}}],"multiPass":"password"}' > /tmp/RTL-Config.json

ENV PORT=3000 \
    APP_PASSWORD=freedomtech \
    LN_IMPLEMENTATION=CLN \
    LN_SERVER_URL=http://core-lightning:3003/v1 \
    MACAROON_PATH=/core-lightning/certs \
    RTL_CONFIG_PATH=/tmp \
    DB_DIRECTORY_PATH=/core-lightning/rtl/ \
    LIGHTNINGD_NETWORK=testnet