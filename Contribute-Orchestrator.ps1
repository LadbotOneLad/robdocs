# ==========================================
# CONTRIBUTION ORCHESTRATOR MONOLITH
# Forward-only, enterprise clean
# ==========================================

$Root    = "C:\robdocs"
$LogFile = Join-Path $Root "contribute-orchestrator.log"

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

Log "=== CONTRIBUTION ORCHESTRATOR START ==="

Flow "git fetch upstream"
Flow "git merge upstream/main"

Flow "git add ."
Flow "git commit -m 'contribution forward flow'"

$Tag = 'v' + (Get-Date -Format 'yyyyMMddHHmmss')
Flow "git tag -a $Tag -m 'witness contribution'"
Flow "git push"
Flow "git push --tags"

Flow "docker compose build"
Flow "docker compose up -d"

Flow "powershell -File $Root\Contribute-Engine.ps1"

Log "=== CONTRIBUTION ORCHESTRATOR END ==="
