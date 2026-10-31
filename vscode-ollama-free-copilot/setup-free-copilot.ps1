<#
  Machine Room Tech - free local Copilot setup (Windows 10/11)
  Pulls Continue's local coding models, installs the Continue extension when the code CLI exists,
  and safely backs up then installs this folder's Continue config.

  Run: powershell -ExecutionPolicy Bypass -File .\setup-free-copilot.ps1 [-Big]
#>
param([switch]$Big)
$ErrorActionPreference = 'Stop'
function Say($text, $color = 'Cyan') { Write-Host "`n>> $text" -ForegroundColor $color }

if (-not (Get-Command ollama -ErrorAction SilentlyContinue)) {
    Say 'Ollama is required. Download it from https://ollama.com/download, then run this script again.' 'Yellow'
    exit 1
}
Say "Ollama is installed: $(ollama --version)" 'Green'
Say 'Downloading autocomplete model qwen2.5-coder:1.5b-base...'
ollama pull qwen2.5-coder:1.5b-base
Say 'Downloading chat model qwen2.5-coder:3b...'
ollama pull qwen2.5-coder:3b
if ($Big) { Say 'Downloading larger chat model qwen2.5-coder:7b...'; ollama pull qwen2.5-coder:7b }

if (Get-Command code -ErrorAction SilentlyContinue) {
    Say 'Installing Continue for VS Code...'
    code --install-extension Continue.continue
} else { Say 'The code command is not on PATH; install Continue manually from the VS Code Extensions view.' 'Yellow' }

$configDir = Join-Path $HOME '.continue'
$configPath = Join-Path $configDir 'config.yaml'
New-Item -ItemType Directory -Force -Path $configDir | Out-Null
if (Test-Path -LiteralPath $configPath) {
    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $backupPath = "$configPath.bak-$stamp"
    $n = 1
    while (Test-Path -LiteralPath $backupPath) { $backupPath = "$configPath.bak-$stamp-$n"; $n++ }
    Copy-Item -LiteralPath $configPath -Destination $backupPath
    Say "Existing config backed up to $backupPath" 'Green'
}
$sourceConfig = Join-Path $PSScriptRoot 'continue-config.yaml'
if (-not (Test-Path -LiteralPath $sourceConfig)) { throw "Missing config file: $sourceConfig" }
Copy-Item -LiteralPath $sourceConfig -Destination $configPath -Force
Say "Config installed at $configPath" 'Green'
Say 'Next: reload VS Code, open the Continue panel, pick Chat mode, and press Tab to accept autocomplete suggestions.' 'Green'
