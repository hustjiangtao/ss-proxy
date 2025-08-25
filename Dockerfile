# Dockerfile
FROM caddy:2-builder AS builder

RUN xcaddy build \
    # --with github.com/caddyserver/forwardproxy@caddy2=github.com/klzgrad/forwardproxy@naive
    --with github.com/caddyserver/forwardproxy=github.com/klzgrad/forwardproxy@naive

# FROM caddy:2
FROM caddy:2-alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy