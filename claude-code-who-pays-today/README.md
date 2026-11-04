# Who Pays Today? (Claude Code from zero)

Companion files for the Machine Room Tech video: a beginner Claude Code tutorial, with a real app built on camera and no code written by hand.

- **Try the app:** https://vigneshraja2021.github.io/who-pays-today/
- **`index.html`:** the finished app from the video. It's one file: double-click it to open it in a browser.

Everything here came from real runs on a laptop with an Intel Core Ultra 5 125H, 16 GB RAM and no graphics card, in November 2026.

## Install

Check [the official install page](https://code.claude.com/docs/en/setup) for the current steps.

Windows (PowerShell):

```powershell
irm https://claude.ai/install.ps1 | iex
```

Mac or Linux:

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

Open a new window and check it worked:

```bash
claude --version
```

## Start

```bash
mkdir who-pays-today
cd who-pays-today
claude
```

Claude Code starts in auto mode, where a second AI checks each action. For your first app, press **Shift+Tab** once to switch to manual mode, so it asks you first.

## What it costs

Claude's Free plan does not include Claude Code. The cheapest plan that does is Pro, at $20 a month before tax. Check the checkout page for your price. Usage limits reset every five hours and every week. The video was recorded on Ultra, so it doesn't show how far this build gets on Pro.

## The prompts from the video

**1. Build it** (what it is, what it does, how it looks, where it goes)

```text
Build me a fun one-page app called "Who Pays Today?". It has a big colourful spin wheel with my friends' names on it: Arun, Priya, Karthik, Divya. I can add or remove names. When I press Spin, the wheel spins and lands on one name, with confetti, and it shows who pays for tea today. Make it look good on a phone. Put everything in one file called index.html.
```

**2. Change it, in Tanglish**

```text
spin aagum bothu tick tick sound venum. yaaru pay pannanumo avanga per-a full screen-la romba perusa kaattu, keela 'Inniku nee thaan!' nu podu.
```

**3. Add a rule**

```text
Remember how many times each person has paid, even after I close the app. Whoever has paid the least gets a bigger slice of the wheel.
```

**4. Have a bad idea**

```text
Make it look like a website from 1998.
```

Then undo it: press **Esc** twice, pick the prompt, and choose **Restore code and conversation**.

**5. Put it online** (read every box: this one makes things public, and you need a free GitHub account)

```text
Put this online for free with GitHub Pages, in a new public repo called who-pays-today, and give me the link.
```

## Before you share yours

- Names in the app's code are public once it's online. Use made-up ones, or start the wheel empty.
- Paid counts live in each browser. They aren't shared between phones, and clearing the browser erases them.
- This app was tested by Claude Code in an emulated phone, not on a real phone.
- An app for your friends is fine. An app that holds other people's money or private data needs someone who can read code.

## The free route: what really happened

Ollama can run a model on your own computer, and Claude Code can talk to it instead of Anthropic's servers: `ollama launch claude`. Ollama's docs ask for a 64k+ context window, which on this laptop meant running the server with `OLLAMA_CONTEXT_LENGTH=65536`.

Results on this laptop, same prompt each time. Only this laptop was measured, and other work ran on it during parts of these runs, so treat the times as approximate. A good GPU or a stronger model could do far better.

| Run | Time | Result |
|---|---|---|
| `qwen3.5:4b`, default settings | 30 min (stopped) | No file. Replies kept being cut off. |
| `gemma4:e4b`, default settings | 30 min (stopped) | No file. Same. |
| `qwen3.5:4b`, timeouts changed | 33 min | Said "Perfect!". No names on the wheel, Spin did nothing: a JavaScript error. |
| Same session, told the exact error | 24 more min | Fixed that error. It spins, but the name list shows twice, two names share a colour, and 5 of 16 test spins announced a name that wasn't under the pointer. |
| Claude's default model (Opus 5.5), for comparison | 6 min 14 s | Worked. Tested itself and caught a real layout bug. |

The cut-offs happen because Claude Code drops a streaming reply after about 5 minutes with no data, and on this CPU, reading the prompt alone can take longer than that. The settings that got past it (PowerShell, in the window where you start Claude Code):

```powershell
$env:API_TIMEOUT_MS="0"
$env:API_FORCE_IDLE_TIMEOUT="0"
$env:CLAUDE_STREAM_IDLE_TIMEOUT_MS="1800000"
$env:CLAUDE_BYTE_STREAM_IDLE_TIMEOUT_MS="1800000"
$env:CLAUDE_STREAM_FIRST_BYTE_TIMEOUT_MS="1800000"
```

Not sponsored by anyone. Tools like Codex and Gemini CLI do similar jobs.
