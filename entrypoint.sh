#!/bin/sh

for f in '/etc/xray/xray.json' '/etc/wireguard/warp.conf';
do
    envsubst < $f | sponge $f
    if [ "$LOG_LEVEL" == "debug" ]; then
        echo -e "$f: \n"
        cat "$f" | sed 's/^/\t/'
        echo
    fi
done

/usr/bin/wg-quick up warp

trace=`curl -Ss --interface warp https://www.cloudflare.com/cdn-cgi/trace/`

if [ "$LOG_LEVEL" == "debug" ]; then
    echo -e "Warp Trace: \n"
    echo -e "$trace \n" | sed 's/^/\t/'
fi

warp_on=`echo "$trace" | grep -e "warp=on" -e "warp=plus"`

if [[ -z "$warp_on" ]]; then
   echo "Couldn't connect to Cloudflare Warp; Terminating..."
   exit 1
fi

exec $@
