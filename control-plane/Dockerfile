# Hindsight Control Plane (web UI). Bump the tag and digest together; see CHANGELOG.md.
FROM ghcr.io/vectorize-io/hindsight-control-plane:1.2.1@sha256:74a113e1f02ace9e8feed954e6b42282e9e3d33b7e0b6d528158d05902552a9a

COPY --chmod=755 railway-start.sh /app/railway-start.sh

EXPOSE 9999
CMD ["/app/railway-start.sh"]
