# ==========================================
# CONTRIBUTION ENGINE MONOLITH
# Forward-only, enterprise clean
# ==========================================

$Root    = "C:\robdocs"
$LogFile = Join-Path $Root "contribute-engine.log"

function Log {
    param([string]$Message)
    $ts = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    "$ts | $Message" | Out-File -Append $LogFile
}

function Flow {
    param([string]$Cmd)
    Log "RUN: $Cmd"
    Push-Location $Root
    Invoke-Expression $Cmd *>&1 | Tee-Object -Append $LogFile
    Pop-Location
}

Log "=== ENGINE START ==="

Flow "docker ps"
Flow "docker logs ai-service --tail 50"
Flow "docker logs robdocs_frontend --tail 50"

Flow "Write-Output 'Contribution engine flow complete'"

Log "=== ENGINE END ==="
