<#
  Machine Room Tech - "Run Your Own AI" setup script (Windows 10/11)

  What it does (nothing else):
    1. Installs Ollama with winget (skipped if it's already installed).
    2. Looks at your RAM and graphics memory and picks a model that should fit.
    3. Downloads that model and runs a quick test question.
    4. Optional: -Lan lets other devices on your home Wi-Fi use it.

  Run it from PowerShell:
    powershell -ExecutionPolicy Bypass -File .\setup-local-ai.ps1
    powershell -ExecutionPolicy Bypass -File .\setup-local-ai.ps1 -Model qwen2.5:3b
    powershell -ExecutionPolicy Bypass -File .\setup-local-ai.ps1 -Lan

  Read it before you run it - it's short on purpose.
#>
param(
    [string]$Model = "",   # force a model instead of the automatic pick
    [switch]$Lan           # also listen on your home network (port 11434)
)

$ErrorActionPreference = "Stop"

function Say($text, $color = "Cyan") { Write-Host "`n>> $text" -ForegroundColor $color }

# --- 1. Install Ollama ------------------------------------------------------
if (Get-Command ollama -ErrorAction SilentlyContinue) {
    Say "Ollama is already installed: $(ollama --version)" "Green"
} else {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Say "winget not found. Install Ollama from https://ollama.com/download, then run this script again." "Yellow"
        exit 1
    }
    Say "Installing Ollama with winget..."
    winget install --id Ollama.Ollama -e --accept-source-agreements --accept-package-agreements
    # winget updates PATH for new windows only; add it for this one.
    $env:Path += ";$env:LOCALAPPDATA\Programs\Ollama"
}

# Make sure the Ollama server is up.
try { Invoke-RestMethod http://127.0.0.1:11434/api/version -TimeoutSec 3 | Out-Null }
catch {
    Say "Starting Ollama..."
    Start-Process ollama -ArgumentList "serve" -WindowStyle Hidden
    Start-Sleep -Seconds 4
}

# --- 2. Pick a model --------------------------------------------------------
$ramGB = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
$vramGB = 0
if (Get-Command nvidia-smi -ErrorAction SilentlyContinue) {
    $mb = (nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits | Select-Object -First 1)
    $vramGB = [math]::Round([int]$mb / 1024)
}
Say "Found: $ramGB GB RAM, $vramGB GB dedicated NVIDIA graphics memory (0 = none or not NVIDIA)."

if (-not $Model) {
    # Rough rule from the video: the model must fit in VRAM (fast) or RAM (slower), with room to spare.
    $budget = if ($vramGB -ge 6) { $vramGB } else { [math]::Floor($ramGB / 2) }
    $Model = if     ($budget -ge 20) { "qwen2.5:14b" }
             elseif ($budget -ge 8)  { "qwen2.5:7b" }
             elseif ($budget -ge 5)  { "qwen3.5:4b" }
             else                    { "qwen2.5:3b" }
}
Say "Model picked: $Model  (change it with -Model <name>)"

# --- 3. Download and test ---------------------------------------------------
Say "Downloading $Model (one time only, a few GB)..."
ollama pull $Model

Say "Quick test - asking the model to say hi:"
ollama run $Model "Say hello in one short sentence."

# --- 4. Optional: home network ----------------------------------------------
if ($Lan) {
    Say "Letting devices on your home network reach Ollama (port 11434)." "Yellow"
    [Environment]::SetEnvironmentVariable("OLLAMA_HOST", "0.0.0.0", "User")
    $ip = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.PrefixOrigin -eq "Dhcp" } | Select-Object -First 1).IPAddress
    Say "Restart Ollama (quit it from the tray, open it again), then connect from your phone or laptop to: http://$($ip):11434" "Green"
    Say "Windows may ask to allow Ollama through the firewall - allow it on PRIVATE networks only." "Yellow"
    Say "Home network only. Never expose port 11434 to the internet - there's no password on it." "Red"
}

Say "Done! Chat any time with:  ollama run $Model" "Green"
