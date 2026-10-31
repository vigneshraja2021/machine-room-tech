# Free Local Copilot in VS Code

Companion to the Machine Room Tech video **"VS Code + Ollama = FREE Copilot (Offline, No GPU)"** (English and Tamil versions).

Video: [English](https://youtu.be/x1fmK_PxS1I) · [Tamil](https://youtu.be/5oMtUO-Acs4)

This video sets up local code autocomplete and chat in VS Code using Ollama and Continue. Your prompts and code stay on your machine.

## Requirements

- VS Code
- [Ollama](https://ollama.com/download)
- 8 GB or more RAM recommended
- No GPU needed; CPU-only works, though larger models are slower

## Three-step setup

1. Install VS Code and Ollama. Open Ollama once so it is ready.
2. Run the setup script below. It downloads the autocomplete model and 3B chat model, installs Continue when the `code` command is available, and installs this folder's config. Add `-Big` / `--big` to also download the 7B model.
3. Reload VS Code, open the Continue panel, choose Chat mode, and press Tab to accept inline suggestions.

### Windows 10 / 11

```powershell
powershell -ExecutionPolicy Bypass -File .\setup-free-copilot.ps1
powershell -ExecutionPolicy Bypass -File .\setup-free-copilot.ps1 -Big
```

### macOS / Linux

```sh
sh setup-free-copilot.sh
sh setup-free-copilot.sh --big
```

### Manual setup

1. Install Ollama and VS Code, then run `ollama pull qwen2.5-coder:1.5b-base` and `ollama pull qwen2.5-coder:3b` (optional: `ollama pull qwen2.5-coder:7b`).
2. In VS Code Extensions, install **Continue** (`Continue.continue`).
3. Copy `continue-config.yaml` to `~/.continue/config.yaml`. Back up an existing file first. Reload VS Code.

## Which models fit?

| Computer | Suggested models |
|---|---|
| 8 GB RAM | 1.5B for autocomplete + 3B for chat |
| 16 GB RAM | 1.5B for autocomplete + 7B for chat |
| NVIDIA GPU | Bigger models can run faster if they fit in graphics memory |

## Measured on the video's laptop

Intel Core Ultra 5 125H, 16 GB RAM, no GPU:

| Task | Model | Measured speed |
|---|---|---|
| Autocomplete | 1.5B | About 3.7 seconds per 64-token suggestion |
| Autocomplete | 7B | About 11 seconds per suggestion |
| Chat | 3B | About 12–15 tokens/second |
| Chat | 7B | About 7 tokens/second |

## Shortcuts

- **Tab**: accept an autocomplete suggestion
- **Ctrl+L**: open Continue chat with selected code
- **Ctrl+I**: edit selected code

## Honest limits

Smaller models make mistakes, so review generated code. Agent mode is too slow on a CPU-only laptop (about 60 seconds per answer); use Chat mode. A GPU and larger models can improve speed and quality.

## Troubleshooting

- **Suggestions are one line:** raise `modelTimeout` in `continue-config.yaml`; this config sets it to 6000 ms because Continue's default 150 ms timeout cuts CPU suggestions short.
- **Nothing appears:** check `ollama list`, then open the Continue output panel in VS Code for errors.
- **First suggestion is slow:** the model may need about 15 seconds to load the first time.
