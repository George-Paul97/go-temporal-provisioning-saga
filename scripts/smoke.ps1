$ErrorActionPreference = "Stop"

function Fail($Message) {
  Write-Error $Message
  exit 1
}

Write-Host "==> Starting Docker Compose stack"
docker compose up -d | Out-Null

Write-Host "==> Waiting for services to become ready"
$deadline = (Get-Date).AddSeconds(60)

while ($true) {
  # Check container states (running / healthy)
  $ps = docker compose ps --format json | ConvertFrom-Json

  if (-not $ps -or $ps.Count -eq 0) {
    if ((Get-Date) -gt $deadline) { Fail "Docker Compose returned no services." }
    Start-Sleep -Seconds 2
    continue
  }

  $allReady = $true
  foreach ($svc in $ps) {
    $state = ($svc.State ?? "").ToLowerInvariant()
    $health = ($svc.Health ?? "").ToLowerInvariant()

    $isRunning = $state -eq "running"
    $isHealthyOrUnknown = ($health -eq "" -or $health -eq "healthy")
    if (-not ($isRunning -and $isHealthyOrUnknown)) {
      $allReady = $false
      break
    }
  }

  if ($allReady) { break }

  if ((Get-Date) -gt $deadline) {
    docker compose ps
    Fail "Services did not become ready within 60 seconds."
  }

  Start-Sleep -Seconds 2
}

docker compose ps

Write-Host "==> Checking Temporal UI (http://localhost:8080)"
try {
  $resp = Invoke-WebRequest -UseBasicParsing -Uri "http://localhost:8080" -TimeoutSec 10
  if ($resp.StatusCode -ne 200) {
    Fail "Temporal UI returned HTTP $($resp.StatusCode)."
  }
  Write-Host "Temporal UI status: $($resp.StatusCode)"
} catch {
  Fail "Temporal UI is not reachable on http://localhost:8080."
}

Write-Host "==> Smoke check passed"
exit 0
