# Deploy and Host Hindsight on Railway

Hindsight is an open-source (MIT) memory server for AI agents from Vectorize. Agents store what they learn with **retain**, fetch it with **recall** (semantic, keyword, graph and time search with reranking) and ask questions over it with **reflect**. It has a REST API, an MCP endpoint, Python and TypeScript SDKs, and a web UI.

## About Hosting Hindsight

Hindsight needs PostgreSQL with the pgvector extension, the API server and, for a UI, the separate Control Plane app. This template deploys all three on Railway's private network. The API runs the official full image, which bundles the local embedding and reranker models, so recall works without any outside service. It runs database migrations and background work on start and stores everything in Postgres on a volume. API-key authentication is on from the first deploy, and the web UI asks for its own generated access key. Add an LLM API key for fact extraction and reflect. Without one, Hindsight still stores and recalls memories. Each service builds from a public GitHub repo, so you get update notices.

## Common Use Cases

* Long-term memory for chatbots, support agents and coding assistants, shared across sessions and users
* A memory server for MCP clients such as Claude Code, Cursor or other agent frameworks
* A private, self-hosted alternative to managed agent-memory services, with your data in your own Postgres

## Dependencies for Hindsight Hosting

* PostgreSQL with pgvector (Railway's PostgreSQL, included)
* Optional: an API key for an LLM provider (OpenAI, Anthropic, Gemini, Groq, OpenRouter, an Ollama server and others)

### Deployment Dependencies

* Hindsight source and releases: https://github.com/vectorize-io/hindsight/releases (this template runs 1.2.1)
* Installation and services: https://hindsight.vectorize.io/developer/installation
* Configuration reference: https://hindsight.vectorize.io/developer/configuration
* Template repository: https://github.com/aalfath/hindsight-railway-template

### Implementation Details

Services:

* **hindsight-api**: the memory API, MCP endpoint and built-in background worker (`ghcr.io/vectorize-io/hindsight-api:1.2.1`, about 1.8 GB RAM at idle because of the local models). Public, and every request needs `Authorization: Bearer HINDSIGHT_API_TENANT_API_KEY`. Health check `/health`.
* **hindsight-control-plane**: the web UI (`ghcr.io/vectorize-io/hindsight-control-plane:1.2.1`). Public, login with `HINDSIGHT_CP_ACCESS_KEY`. It calls the API over the private network. Health check `/api/health`.
* **Postgres**: Railway PostgreSQL 18 with pgvector, on a volume. Private only.

After deploy:

1. Open the `hindsight-control-plane` URL and log in with the `HINDSIGHT_CP_ACCESS_KEY` value from that service's Variables tab.
2. To use the API, copy `HINDSIGHT_API_TENANT_API_KEY` from `hindsight-api` and try it:

```
curl -X POST "https://YOUR-API-DOMAIN/v1/default/banks/my-bank/memories" \
  -H "Authorization: Bearer YOUR-API-KEY" -H "Content-Type: application/json" \
  -d '{"items":[{"content":"Ada works at Railway and loves hiking."}]}'
curl -X POST "https://YOUR-API-DOMAIN/v1/default/banks/my-bank/memories/recall" \
  -H "Authorization: Bearer YOUR-API-KEY" -H "Content-Type: application/json" \
  -d '{"query":"Where does Ada work?"}'
```

3. For fact extraction, observations and reflect, set `HINDSIGHT_API_LLM_API_KEY` (and `HINDSIGHT_API_LLM_PROVIDER` if it isn't OpenAI) on `hindsight-api`. Other settings such as `HINDSIGHT_API_LLM_MODEL` or `HINDSIGHT_API_LLM_BASE_URL` are listed in the configuration reference.

Updates: when a new Hindsight release is tested, the template repo's pinned version moves on `main` and Railway shows you an update notice. Read the repo's CHANGELOG before you apply it: the API migrates the database on start.

## Why Deploy Hindsight on Railway?

<!-- Recommended: Keep this section as shown below -->
Railway is a singular platform to deploy your infrastructure stack. Railway will host your infrastructure so you don't have to deal with configuration, while allowing you to vertically and horizontally scale it.

By deploying Hindsight on Railway, you are one step closer to supporting a complete full-stack application with minimal burden. Host your servers, databases, AI agents, and more on Railway.
<!-- End recommended section -->
