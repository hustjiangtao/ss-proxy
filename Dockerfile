# Dockerfile
FROM caddy:2-builder AS builder

RUN xcaddy build \
    # --with github.com/caddyserver/forwardproxy@caddy2=github.com/klzgrad/forwardproxy@naive
    --with github.com/caddyserver/forwardproxy=github.com/klzgrad/forwardproxy@naive

FROM caddy:2

# 添加容器元数据，这对 GitHub Container Registry 很重要
LABEL org.opencontainers.image.source="https://github.com/hustjiangtao/ss-proxy"
LABEL org.opencontainers.image.description="Caddy server with naive proxy support"
LABEL org.opencontainers.image.licenses="AGPL-3.0"

COPY --from=builder /usr/bin/caddy /usr/bin/caddy