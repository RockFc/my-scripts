# 1. Define network names
$Networks = @("dev-net", "ai-net")

Write-Host "Checking Docker Backbone Networks..." -ForegroundColor Cyan

# 2. Get existing networks
$ExistingNetworks = docker network ls --format "{{.Name}}"

# 3. Loop and check/create
foreach ($Net in $Networks) {
    if ($ExistingNetworks -contains $Net) {
        Write-Host "[OK] Network already exists: $Net" -ForegroundColor Green
    } else {
        Write-Host "[INFO] Network not found, creating: $Net ..." -ForegroundColor Yellow
        docker network create $Net | Out-Null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "[SUCCESS] Created network: $Net" -ForegroundColor Green
        } else {
            Write-Host "[ERROR] Failed to create network: $Net" -ForegroundColor Red
        }
    }
}

# 4. Show final status
Write-Host "Current active networks:" -ForegroundColor Cyan
docker network ls --filter "name=dev-net" --filter "name=ai-net"