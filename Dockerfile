# syntax=docker/dockerfile:1

FROM teddysun/xray:latest AS xray
FROM alpine

USER root

RUN apk add curl                        # for: curl
RUN apk add envsubst                    # for: envsubst
RUN apk add moreutils                   # for: sponge
RUN apk add wireguard-tools-wg-quick    # for: wg-quick

ENV LOG_LEVEL=info

ENV WARP_ENDPOINT=engage.cloudflareclient.com:2408
ENV WARP_MTU=1200
ENV WARP_DNS="1.1.1.1, 1.0.0.1"
ENV WARP_ADDRESS=172.16.0.2/32
ENV WARP_PUBLIC_KEY=bmXOC+F1FxEMF9dyiK2H5/1SUtzH0JuVo51h2wPfgyo=
ENV WARP_PRIVATE_KEY=

COPY --from=xray --chmod=755 /usr/bin/xray /usr/bin/xray
COPY --chmod=600 ./warp.conf /etc/wireguard/
COPY ./xray.json /etc/xray/xray.json
COPY --chmod=755 ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/bin/xray", "run", "-c", "/etc/xray/xray.json"]

EXPOSE 80

HEALTHCHECK --interval=15m \
    --start-interval=5s \
    --start-period=5s \
    CMD curl -Ss --interface warp https://www.cloudflare.com/cdn-cgi/trace/ | egrep -q "warp=on|warp=plus" && nc -z localhost 80 || exit 1
