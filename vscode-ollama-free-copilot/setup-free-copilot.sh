#!/usr/bin/env sh
# Machine Room Tech - free local Copilot setup (macOS / Linux)
# Run: sh setup-free-copilot.sh [--big]
set -eu
say() { printf '\n>> %s\n' "$1"; }
BIG=0
for arg in "$@"; do
  case "$arg" in --big) BIG=1 ;; *) say "Unknown option: $arg (use --big)"; exit 2 ;; esac
done
if ! command -v ollama >/dev/null 2>&1; then
  say 'Ollama is required. Download it from https://ollama.com/download, then run this script again.'
  exit 1
fi
say "Ollama is installed: $(ollama --version)"
say 'Downloading autocomplete model qwen2.5-coder:1.5b-base...'
ollama pull qwen2.5-coder:1.5b-base
say 'Downloading chat model qwen2.5-coder:3b...'
ollama pull qwen2.5-coder:3b
if [ "$BIG" -eq 1 ]; then
  say 'Downloading larger chat model qwen2.5-coder:7b...'
  ollama pull qwen2.5-coder:7b
fi
if command -v code >/dev/null 2>&1; then
  say 'Installing Continue for VS Code...'
  code --install-extension Continue.continue
else
  say 'The code command is not on PATH; install Continue manually from the VS Code Extensions view.'
fi
CONFIG_DIR="$HOME/.continue"
CONFIG_PATH="$CONFIG_DIR/config.yaml"
mkdir -p "$CONFIG_DIR"
if [ -e "$CONFIG_PATH" ]; then
  STAMP=$(date '+%Y%m%d-%H%M%S')
  BACKUP="$CONFIG_PATH.bak-$STAMP"
  N=1
  while [ -e "$BACKUP" ]; do BACKUP="$CONFIG_PATH.bak-$STAMP-$N"; N=$((N + 1)); done
  cp -p "$CONFIG_PATH" "$BACKUP"
  say "Existing config backed up to $BACKUP"
fi
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
if [ ! -f "$SCRIPT_DIR/continue-config.yaml" ]; then say "Missing config file: $SCRIPT_DIR/continue-config.yaml"; exit 1; fi
cp "$SCRIPT_DIR/continue-config.yaml" "$CONFIG_PATH"
say "Config installed at $CONFIG_PATH"
say 'Next: reload VS Code, open the Continue panel, pick Chat mode, and press Tab to accept autocomplete suggestions.'
