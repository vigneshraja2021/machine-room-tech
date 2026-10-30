#!/usr/bin/env sh
# Machine Room Tech - "Run Your Own AI" setup script (macOS / Linux)
#
# What it does (nothing else):
#   1. Installs Ollama (Linux: official install script; macOS: Homebrew) if it's missing.
#   2. Looks at your memory and picks a model that should fit.
#   3. Downloads that model and runs a quick test question.
#
# Run it:
#   sh setup-local-ai.sh                 # automatic pick
#   sh setup-local-ai.sh qwen2.5:3b      # force a model
#
# Read it before you run it - it's short on purpose.
set -e

say() { printf '\n>> %s\n' "$1"; }
MODEL="$1"

# --- 1. Install Ollama ------------------------------------------------------
if command -v ollama >/dev/null 2>&1; then
  say "Ollama is already installed: $(ollama --version)"
elif [ "$(uname)" = "Darwin" ]; then
  if command -v brew >/dev/null 2>&1; then
    say "Installing Ollama with Homebrew..."
    brew install ollama
  else
    say "Install the Ollama app from https://ollama.com/download, then run this script again."
    exit 1
  fi
else
  say "Installing Ollama with the official script from ollama.com..."
  curl -fsSL https://ollama.com/install.sh | sh
fi

# Make sure the Ollama server is up.
if ! curl -s -m 3 http://127.0.0.1:11434/api/version >/dev/null; then
  say "Starting Ollama..."
  (ollama serve >/dev/null 2>&1 &)
  sleep 4
fi

# --- 2. Pick a model --------------------------------------------------------
if [ "$(uname)" = "Darwin" ]; then
  MEM_GB=$(( $(sysctl -n hw.memsize) / 1073741824 ))
  BUDGET=$(( MEM_GB * 2 / 3 ))   # Apple Silicon shares memory with the GPU
else
  MEM_GB=$(( $(awk '/MemTotal/ {print $2}' /proc/meminfo) / 1048576 ))
  VRAM_GB=0
  if command -v nvidia-smi >/dev/null 2>&1; then
    VRAM_GB=$(( $(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits | head -1) / 1024 ))
  fi
  if [ "$VRAM_GB" -ge 6 ]; then BUDGET=$VRAM_GB; else BUDGET=$(( MEM_GB / 2 )); fi
fi
say "Found about $MEM_GB GB memory. Model budget: $BUDGET GB."

if [ -z "$MODEL" ]; then
  if   [ "$BUDGET" -ge 20 ]; then MODEL="qwen2.5:14b"
  elif [ "$BUDGET" -ge 8 ];  then MODEL="qwen2.5:7b"
  elif [ "$BUDGET" -ge 5 ];  then MODEL="qwen3.5:4b"
  else                            MODEL="qwen2.5:3b"
  fi
fi
say "Model picked: $MODEL  (force another: sh setup-local-ai.sh <model>)"

# --- 3. Download and test ---------------------------------------------------
say "Downloading $MODEL (one time only, a few GB)..."
ollama pull "$MODEL"

say "Quick test - asking the model to say hi:"
ollama run "$MODEL" "Say hello in one short sentence."

say "Done! Chat any time with:  ollama run $MODEL"
say "Want it on your home Wi-Fi? See the README (OLLAMA_HOST). Never expose port 11434 to the internet."
