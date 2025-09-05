# syntax=docker/dockerfile:1

# Base: official multi-arch Portainer CE image
FROM portainer/portainer-ce:latest

# Expose UI/HTTPS (9443) and Edge agent (8000)
EXPOSE 9443 8000

# Portainer stores its state in /data
VOLUME ["/data"]

# The upstream image already defines the correct ENTRYPOINT/CMD.
# No extra commands needed here.
