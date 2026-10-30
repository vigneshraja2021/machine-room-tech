# Run Your Own AI — setup scripts

Companion to the Machine Room Tech video **"I Put an AI Brain Inside My PC (and You Can Too)"**.

These scripts do exactly what the video does, in one go:

1. Install [Ollama](https://ollama.com) (skipped if you already have it).
2. Check your RAM / graphics memory and pick a model that should fit.
3. Download the model and ask it a quick test question.

Read the script before running it. Both are short on purpose.

## Windows 10 / 11

Download `setup-local-ai.ps1`, open PowerShell in that folder, and run:

```powershell
powershell -ExecutionPolicy Bypass -File .\setup-local-ai.ps1
```

Options:

| Option | What it does |
|---|---|
| `-Model qwen2.5:3b` | Use this model instead of the automatic pick |
| `-Lan` | Also let your phone / other PCs on your **home** Wi-Fi use it |

## macOS / Linux

```sh
sh setup-local-ai.sh             # automatic pick
sh setup-local-ai.sh qwen2.5:3b  # force a model
```

## Which model does it pick?

| Memory budget | Model | Download |
|---|---|---|
| under 5 GB | `qwen2.5:3b` | ~1.9 GB |
| 5–7 GB | `qwen3.5:4b` | ~3.3 GB |
| 8–19 GB | `qwen2.5:7b` | ~4.7 GB |
| 20 GB+ | `qwen2.5:14b` | ~9 GB |

The budget is your NVIDIA graphics memory if you have 6 GB or more, otherwise about half your RAM (two-thirds on a Mac).

## Using it on your home Wi-Fi

Windows: run with `-Lan`, restart Ollama, then connect from another device to `http://<your-PC-IP>:11434`.
macOS / Linux: start Ollama with `OLLAMA_HOST=0.0.0.0 ollama serve`.

> **Home network only.** Never forward or expose port 11434 to the internet — Ollama has no password.

## Handy commands

```
ollama run <model>   chat with a model
ollama list          models you've downloaded
ollama ps            what's loaded right now, and on CPU or GPU
/bye                 leave the chat
```
