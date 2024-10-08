#!/bin/bash

if [[ -z "${WARP_PRIVATE_KEY}" ]]; then
    echo "missing required environment variable WARP_PRIVATE_KEY"
    exit 1
fi

for f in '/etc/xray/xray.json' '/etc/wireguard/warp.conf'; do
    envsubst <"$f" | sponge "$f"
    if [ "$LOG_LEVEL" == "debug" ]; then
        echo -e "$f: \n"
        sed 's/^/\t/' "$f"
        echo
    fi
done

/usr/bin/wg-quick up warp

trace=$(curl -Ss --interface warp https://www.cloudflare.com/cdn-cgi/trace/)

echo -e "Warp Trace: \n"
echo -e "$trace \n" | sed 's/^/\t/'

exec "$@"
