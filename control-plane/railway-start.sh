#!/bin/bash
# Railway wrapper for the Hindsight Control Plane (Next.js UI).
set -e

# The UI is public: never start it without its login key.
if [ -z "${HINDSIGHT_CP_ACCESS_KEY:-}" ]; then
  echo "HINDSIGHT_CP_ACCESS_KEY is empty. Refusing to start the Control Plane without a login key." >&2
  exit 1
fi
if [ -z "${HINDSIGHT_CP_DATAPLANE_API_URL:-}" ]; then
  echo "HINDSIGHT_CP_DATAPLANE_API_URL is empty. It should point at the hindsight-api service's private URL." >&2
  exit 1
fi

export HINDSIGHT_CP_PORT="${PORT:-${HINDSIGHT_CP_PORT:-9999}}"
export HINDSIGHT_CP_HOSTNAME="${HINDSIGHT_CP_HOSTNAME:-0.0.0.0}"

export HINDSIGHT_ENABLE_API=false
export HINDSIGHT_ENABLE_CP=true
exec /app/start-all.sh
