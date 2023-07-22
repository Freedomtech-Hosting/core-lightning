#!/usr/bin/env bash

# Original: https://github.com/ElementsProject/lightning/blob/master/tools/docker-entrypoint.sh

set -e

: "${EXPOSE_TCP:=false}"

# envplating the core-lightning config
ep /etc/core-lightning.conf

networkdatadir="${LIGHTNINGD_DATA}/${LIGHTNINGD_NETWORK}"

# enable Bash Job Control
set -m

# Setup and Start TOR
mkdir -p /root/.lightning/tor
tor -f /etc/torrc &

# Prepping certs folder, used by the core-lightning-rest plugin
# This mounts the certs folder in our persistent storage, so other tools like rtl can access them
mkdir -p /root/.lightning/certs
rm -rf /usr/local/libexec/c-lightning/plugins/c-lightning-rest/certs
ln -s /root/.lightning/certs /usr/local/libexec/c-lightning/plugins/c-lightning-rest/certs

# starting core lightning
lightningd --network="${LIGHTNINGD_NETWORK}" --conf="/etc/core-lightning.conf" "$@" &

echo "Core-Lightning starting"
while read -r i; do if [ "$i" = "lightning-rpc" ]; then break; fi; done \
    < <(inotifywait -e create,open --format '%f' --quiet "${networkdatadir}" --monitor)

if [ "$EXPOSE_TCP" == "true" ]; then
    echo "Core-Lightning started, RPC available on port $LIGHTNINGD_RPC_PORT"

    socat "TCP4-listen:$LIGHTNINGD_RPC_PORT,fork,reuseaddr" "UNIX-CONNECT:${networkdatadir}/lightning-rpc" &
fi

# Now run any scripts which exist in the lightning-poststart.d directory
if [ -d "$LIGHTNINGD_DATA"/lightning-poststart.d ]; then
    for f in "$LIGHTNINGD_DATA"/lightning-poststart.d/*; do
	"$f"
    done
fi

fg %-