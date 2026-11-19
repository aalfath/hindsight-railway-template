# Changelog

## 1.2.1 (2026-11-19)

- First release of the template: Hindsight `1.2.1`.
  - `hindsight-api`: `ghcr.io/vectorize-io/hindsight-api:1.2.1@sha256:662109ece429871a81e036427fb93fbb09ba9dc4b01d320d356f114c0e1aedd8`
  - `hindsight-control-plane`: `ghcr.io/vectorize-io/hindsight-control-plane:1.2.1@sha256:74a113e1f02ace9e8feed954e6b42282e9e3d33b7e0b6d528158d05902552a9a`
  - Railway PostgreSQL with pgvector.
- `hindsight-api` start script: API-key auth required, LLM provider falls back to `none` when no LLM key is set, stable `HINDSIGHT_API_WORKER_ID` so background tasks survive redeploys.
- README: Deploy on Railway button.
