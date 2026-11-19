[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/hindsight-1?utm_medium=integration&utm_source=button&utm_campaign=hindsight)

# Hindsight on Railway

One-click Railway template for [Hindsight](https://github.com/vectorize-io/hindsight), the open-source agent memory server from Vectorize (MIT). Your AI agents get a long-term memory API: **retain**, **recall** and **reflect**, over REST, MCP and the Python/TypeScript SDKs.

**Version:** Hindsight `1.2.1` (official images, pinned by digest in each service's `Dockerfile`).

## What it deploys

| Service | Built from | What it does | Public | Storage |
|---|---|---|---|---|
| `hindsight-api` | `api/` (`ghcr.io/vectorize-io/hindsight-api:1.2.1`, full image with the local embedding and reranker models) | Memory API, MCP endpoint, background worker, database migrations | Yes, API-key protected | Stateless: everything lives in Postgres |
| `hindsight-control-plane` | `control-plane/` (`ghcr.io/vectorize-io/hindsight-control-plane:1.2.1`) | Web UI to browse memory banks, entities and documents and to test recall | Yes, behind an access key | None |
| `Postgres` | Railway PostgreSQL (ships pgvector) | Memories, vectors, the task queue and uploaded files | No (private network) | Railway volume |

The API reaches Postgres and the Control Plane reaches the API over Railway's private network, through reference variables.

## Variables

| Service | Variable | Default | Notes |
|---|---|---|---|
| `hindsight-api` | `HINDSIGHT_API_TENANT_API_KEY` | `${{secret(48)}}` | Bearer key every client sends (`Authorization: Bearer …`). The start script refuses to run without it. |
| `hindsight-api` | `HINDSIGHT_API_LLM_PROVIDER` | `openai` | Any provider Hindsight supports (`openai`, `anthropic`, `gemini`, `groq`, `openrouter`, `ollama`, …). |
| `hindsight-api` | `HINDSIGHT_API_LLM_API_KEY` | empty (optional) | Your LLM key. Left empty, Hindsight runs with provider `none`: storage and semantic recall work, fact extraction and reflect don't. |
| `hindsight-api` | `HINDSIGHT_API_DATABASE_URL` | `${{Postgres.DATABASE_URL}}` | Private Postgres URL. |
| `hindsight-api` | `PORT` | `8888` | Port the API listens on. |
| `hindsight-control-plane` | `HINDSIGHT_CP_ACCESS_KEY` | `${{secret(32)}}` | Password for the web UI. The start script refuses to run without it. |
| `hindsight-control-plane` | `HINDSIGHT_CP_DATAPLANE_API_URL` | `http://${{hindsight-api.RAILWAY_PRIVATE_DOMAIN}}:${{hindsight-api.PORT}}` | Private API URL. |
| `hindsight-control-plane` | `HINDSIGHT_CP_DATAPLANE_API_KEY` | `${{hindsight-api.HINDSIGHT_API_TENANT_API_KEY}}` | The UI uses the API's key. |
| `hindsight-control-plane` | `PORT` | `9999` | Port the UI listens on. |

Any other `HINDSIGHT_API_*` setting from the [configuration reference](https://hindsight.vectorize.io/developer/configuration) can be added to `hindsight-api` (for example `HINDSIGHT_API_LLM_MODEL` or `HINDSIGHT_API_LLM_BASE_URL`).

## Updates

Each service builds from this repository. When a new Hindsight release is tested, the pinned tag and digest are bumped on `main` and listed in [CHANGELOG.md](CHANGELOG.md). Railway then shows an "update available" notice on your project, and you choose when to apply it. Hindsight runs its database migrations on start, so read the changelog for breaking changes before you apply an update.

## Layout

- `OVERVIEW.md`: the marketplace overview of the template.

- `api/Dockerfile`, `api/railway-start.sh`: the API service (listens on `PORT`, API-key auth on, LLM fallback to `none`).
- `control-plane/Dockerfile`, `control-plane/railway-start.sh`: the web UI (listens on `PORT`, refuses to start without an access key).

No `railway.json`: health checks (`/health` for the API, `/api/health` for the UI) are set on the template's services.
