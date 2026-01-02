# Go Temporal Provisioning Saga

A small reference project that demonstrates **Temporal workflows** + **API integrations** + **observability** for real-world automation scenarios.

This repo starts with a **local Temporal stack** (Temporal + Postgres + Temporal UI) and will evolve into:
- a REST API service
- a Temporal Worker running workflows/activities
- mock provider integrations
- OpenTelemetry-based tracing/metrics/logging

---

## Local Infrastructure (Temporal + Postgres)

### Services
This project runs the following services via Docker Compose:

- **Postgres** (Temporal persistence)
- **Temporal** (server)
- **Temporal UI** (web dashboard)

### Prerequisites
- Docker Desktop (Windows/macOS/Linux)
- Docker Compose v2 (`docker compose ...`)

---

## Quickstart

### Start the stack
From the project root:

```bash
docker compose up -d
