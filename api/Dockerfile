# Hindsight API (official full image: local embedder + reranker baked in).
# Bump the tag and digest together; see CHANGELOG.md.
FROM ghcr.io/vectorize-io/hindsight-api:1.2.1@sha256:662109ece429871a81e036427fb93fbb09ba9dc4b01d320d356f114c0e1aedd8

COPY --chmod=755 railway-start.sh /app/railway-start.sh

EXPOSE 8888
CMD ["/app/railway-start.sh"]
