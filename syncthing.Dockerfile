# Dockerfile
FROM alpine:3.20

# Install syncthing and a tiny init
RUN apk add --no-cache syncthing ca-certificates tzdata dumb-init

# Create an unprivileged user & home for Syncthing data/config
# (defaults to UID/GID 1000; adjust if you need different ownership on bind mounts)
RUN addgroup -S -g 1000 syncthing \
 && adduser  -S -D -u 1000 -G syncthing -h /var/syncthing syncthing \
 && mkdir -p /var/syncthing \
 && chown -R syncthing:syncthing /var/syncthing

# Environment
ENV STNOUPGRADE=1 \
    STGUIADDRESS=0.0.0.0:8384 \
    STHOME=/var/syncthing

# Persist config/database
VOLUME ["/var/syncthing"]

# Syncthing ports:
# 8384/tcp  - Web GUI/API
# 22000/tcp - Sync (TCP)
# 22000/udp - Sync QUIC (UDP)
# 21027/udp - Local discovery (UDP)
EXPOSE 8384/tcp 22000/tcp 22000/udp 21027/udp

# Simple healthcheck: ensures the syncthing process is present
HEALTHCHECK --interval=30s --timeout=5s --retries=5 CMD pgrep -x syncthing >/dev/null || exit 1

# Run as the unprivileged user under a minimal init for proper signal handling
USER syncthing
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["syncthing", "-home=/var/syncthing", "-no-browser", "-gui-address=${STGUIADDRESS}"]
