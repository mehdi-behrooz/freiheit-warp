### Intro
Connects to Cloudflare's Warp and Listens on a socks proxy on port 80.

### Usage

```yaml

services:
  warp:
    container_name: warp
    image: ghcr.io/mehdi-behrooz/freiheit-warp:latest
    cap_add:
      - NET_ADMIN
    environment:
      - WARP_PRIVATE_KEY=${WARP_PRIVATE_KEY}
      - WARP_PUBLIC_KEY=${WARP_PRIVATE_KEY}               # optional
      - WARP_ENDPOINT=engage.cloudflareclient.com:2408    # optional
      - WARP_MTU=1200                                     # optional
      - WARP_DNS="1.1.1.1, 1.0.0.1"                       # optional

```
