ARG CORE_LIGHTNING_IMAGE=elementsproject/lightningd:v23.05.1

FROM saubyk/c-lightning-rest:0.10.5 as core-lightning-rest
FROM uselagoon/commons as lagoon-commons
FROM ${CORE_LIGHTNING_IMAGE} as core-lightning

COPY --from=lagoon-commons /bin/fix-permissions /bin/ep /bin/

USER root

# Install TOR and NodeJS (needed for core-lightning-rest)
RUN apt update && apt install -y gpg wget curl \
    && echo "deb [signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] http://deb.torproject.org/torproject.org bullseye main" >> /etc/apt/sources.list \
    && wget -qO- https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --dearmor | tee /usr/share/keyrings/tor-archive-keyring.gpg >/dev/null \
    && apt update && apt install -y tor deb.torproject.org-keyring \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

COPY torrc /etc/torrc

COPY --from=core-lightning-rest /usr/src/app /usr/local/libexec/c-lightning/plugins/c-lightning-rest

COPY core-lightning.conf /etc/core-lightning.conf
RUN fix-permissions /etc/core-lightning.conf \
    && fix-permissions /root \
    && fix-permissions /usr/local/libexec/c-lightning/plugins/c-lightning-rest

ENV LIGHTNINGD_NETWORK=testnet \
    HOME=/root

COPY start-core-lightning.sh /entrypoint.sh
