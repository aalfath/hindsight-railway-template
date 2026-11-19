#!/bin/bash
# Railway wrapper for the Hindsight API. Sets safe defaults, then hands over to
# upstream's /app/start-all.sh (API only; the Control Plane is its own service).
set -e

# Railway variables that were left blank arrive as empty strings: treat them as unset.
for v in HINDSIGHT_API_LLM_PROVIDER HINDSIGHT_API_LLM_API_KEY HINDSIGHT_API_LLM_MODEL HINDSIGHT_API_LLM_BASE_URL; do
  if [ -z "${!v}" ]; then unset "$v"; fi
done

if [ -z "${HINDSIGHT_API_DATABASE_URL:-}" ]; then
  echo "HINDSIGHT_API_DATABASE_URL is empty. It should reference the Postgres service (\${{Postgres.DATABASE_URL}})." >&2
  exit 1
fi

# Never run an open API on a public URL.
if [ -z "${HINDSIGHT_API_TENANT_API_KEY:-}" ]; then
  echo "HINDSIGHT_API_TENANT_API_KEY is empty. Refusing to start without API-key authentication." >&2
  exit 1
fi
export HINDSIGHT_API_TENANT_EXTENSION="${HINDSIGHT_API_TENANT_EXTENSION:-hindsight_api.extensions.builtin.tenant:ApiKeyTenantExtension}"

# LLM: with no key and no custom endpoint, run in "none" mode (chunk storage and
# semantic recall work; fact extraction and reflect need an LLM).
if [ -z "${HINDSIGHT_API_LLM_PROVIDER:-}" ]; then
  if [ -n "${HINDSIGHT_API_LLM_API_KEY:-}" ]; then
    export HINDSIGHT_API_LLM_PROVIDER=openai
  else
    export HINDSIGHT_API_LLM_PROVIDER=none
  fi
fi
if [ "$HINDSIGHT_API_LLM_PROVIDER" != "none" ] && [ -z "${HINDSIGHT_API_LLM_API_KEY:-}" ] && [ -z "${HINDSIGHT_API_LLM_BASE_URL:-}" ]; then
  echo "HINDSIGHT_API_LLM_PROVIDER=$HINDSIGHT_API_LLM_PROVIDER but no HINDSIGHT_API_LLM_API_KEY or HINDSIGHT_API_LLM_BASE_URL is set: falling back to provider 'none'."
  export HINDSIGHT_API_LLM_PROVIDER=none
fi
echo "Hindsight LLM provider: $HINDSIGHT_API_LLM_PROVIDER"

# Listen on Railway's PORT, on IPv4 and IPv6 (Railway's private network can be IPv6-only).
export HINDSIGHT_API_PORT="${PORT:-${HINDSIGHT_API_PORT:-8888}}"
export HINDSIGHT_API_HOST="${HINDSIGHT_API_HOST:-::}"

export HINDSIGHT_ENABLE_API=true
export HINDSIGHT_ENABLE_CP=false
exec /app/start-all.sh
