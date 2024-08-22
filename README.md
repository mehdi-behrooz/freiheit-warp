# Freiheit Warp

## Intro

Connects to Cloudflare's Warp and listens on a socks proxy on port 80.

## Usage

### docker run

```bash
docker run --cap-add=NET_ADMIN \
        -e WARP_PRIVATE_KEY=${WARP_PRIVATE_KEY}
        ghcr.io/mehdi-behrooz/freiheit-warp
```

### docker compose

```yaml
services:
  warp:
    container_name: warp
    image: ghcr.io/mehdi-behrooz/freiheit-warp:latest
    cap_add:
      - NET_ADMIN
    environment:
      - WARP_PRIVATE_KEY=${WARP_PRIVATE_KEY}
      - WARP_PUBLIC_KEY=${WARP_PUBLIC_KEY} # optional
      - WARP_ENDPOINT=engage.cloudflareclient.com:2408 # optional
      - WARP_MTU=1200 # optional
      - WARP_DNS="1.1.1.1, 1.0.0.1" # optional
      - LOG_LEVEL=debug # optional
```

## Test

```bash
curl -sx socks5://127.0.0.1:8000 ip.sb
curl -sx socks5://127.0.0.1:8000 https://www.cloudflare.com/cdn-cgi/trace/
```
