$ErrorActionPreference = "Stop"

Write-Host "==> Starting stack"
docker compose up -d | Out-Null

Write-Host "==> Waiting for containers"
docker compose ps

Write-Host "==> Checking Temporal UI (http://localhost:8080)"
try {
  $resp = Invoke-WebRequest -UseBasicParsing -Uri "http://localhost:8080" -TimeoutSec 10
  Write-Host "Temporal UI status:" $resp.StatusCode
} catch {
  Write-Error "Temporal UI is not reachable on http://localhost:8080"
  throw
}

Write-Host "==> Done"