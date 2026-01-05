#!/usr/bin/env bash
set -euo pipefail

docker compose up -d
docker compose ps

curl -fsS http://localhost:8080 >/dev/null
echo "OK: Temporal UI reachable at http://localhost:8080"
