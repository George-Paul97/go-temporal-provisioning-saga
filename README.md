# go-temporal-provisioning-saga

A minimal **Go + Temporal + Postgres** stack using Docker Compose, plus a small CI baseline:
- **Go quality gate**: `gofmt` + `go vet` + `go test`
- **ai-guard PR gate**: lightweight security/hygiene scan on pull requests

The repo is intentionally small: it’s meant to be a clean starting point you can fork and extend.

## What you get

Services (via Docker Compose):
- **Temporal Server** (gRPC): `localhost:7233`
- **Temporal UI** (HTTP): `http://localhost:8080`
- **Postgres** (TCP): `localhost:5432`

Important:
- `7233` is **gRPC**, not HTTP → opening `http://localhost:7233/` in a browser will fail (expected).
- `5432` is **Postgres TCP**, not HTTP → opening it in a browser will fail (expected).

## Requirements

- Docker Desktop (running)
- Go (recommended for local dev and to run the same checks as CI)

## Quick start

### Start the stack

```bash
docker compose up -d
docker compose ps
