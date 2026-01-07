#!/usr/bin/env bash
set -euo pipefail

fail() {
  echo "ERROR: $*" >&2
  exit 1
}

echo "==> Starting Docker Compose stack"
docker compose up -d >/dev/null

echo "==> Waiting for services to become ready"
deadline=$((SECONDS + 60))

while true; do
  # If Docker supports health checks, prefer them; otherwise only require "running".
  # Compose v2 prints status per service. We treat "healthy" as best-case, but do not require it unless present.
  out="$(docker compose ps 2>/dev/null || true)"
  echo "$out" | grep -qE 'Up' || {
    [[ $SECONDS -gt $deadline ]] && { docker compose ps; fail "Services did not reach 'Up' state within 60 seconds."; }
    sleep 2
    continue
  }

  # If any service explicitly reports "unhealthy", fail fast.
  echo "$out" | grep -qiE 'unhealthy' && { docker compose ps; fail "A service is reporting unhealthy status."; }

  break
done

docker compose ps

echo "==> Checking Temporal UI (http://localhost:8080)"
curl -fsS --max-time 10 http://localhost:8080 >/dev/null || fail "Temporal UI is not reachable on http://localhost:8080."

echo "==> Smoke check passed"
