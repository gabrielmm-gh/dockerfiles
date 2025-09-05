# syntax=docker/dockerfile:1

# Official Homepage image (pin a version instead of :latest)
FROM ghcr.io/gethomepage/homepage:v1.4.6

# Homepage listens on 3000
EXPOSE 3000

# Persist your YAML config (settings.yaml, services.yaml, etc.)
VOLUME ["/app/config"]

# Allowed hosts are required for access from anything other than localhost.
# Override at runtime as needed (comma-separated, include port if applicable).
ENV HOMEPAGE_ALLOWED_HOSTS=localhost:3000,127.0.0.1:3000 \
    PUID=0 \
    PGID=0

# Basic healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=15s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/api/healthcheck || exit 1

# Upstream image already provides the entrypoint/cmd.
