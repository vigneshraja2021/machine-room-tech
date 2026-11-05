# Opus 5.5 "regression" reports: research

Checked 2026-11-05. Disclosure: this research was done by Claude, which Anthropic makes, so every claim below carries a source you can check yourself.

**How each source was read**
- **Direct**: I fetched the page or API myself (GitHub API, status page API, LiveNerf repo, Hacker News API, Anthropic pages, YouTube search).
- **Secondary**: a blog reports it and I could not open the original. Reddit blocked the fetch tool, the search tool and the built-in browser, so every Reddit thread below is secondary. X posts marked Direct were opened in the browser on Nov 5; times shown are the browser's local time.

A second pass on Nov 5 re-read the X posts, the April postmortem, the Claude Code changelog and the model-switching help article first-hand. It corrected two rows (the Thariq post and the Boris Cherny post) and added section 3a.

## Short answer

Many paying users say Opus 5.5 got worse, in two waves (around Sep 29 to Oct 3, and from about Oct 19). No public measurement shows the model itself changed, and the one benchmark built to catch exactly this reports "no change" through Nov 4. Anthropic has published no statement or postmortem on it. Three documented things can make it feel worse without the model changing: a `medium` default effort, automatic switching to older models on flagged requests, and usage limits draining faster.

## 1. What users report

| When | Where | What | Read |
|---|---|---|---|
| Sep 23 to 25 | GitHub [#96327](https://github.com/anthropics/claude-code/issues/96327), [#97117](https://github.com/anthropics/claude-code/issues/97117) | Launch-week complaints: lost legal reasoning, scope creep versus Opus 4.6. 0 reactions each. | Direct |
| Oct 1 to 2 | Reddit r/ClaudeCode and r/ClaudeAI | "Nerfed" threads with 1,090 votes / 503 comments and 937 votes; a one-off Godot test with 599 votes | Secondary ([Pillitteri, Oct 3](https://pasqualepillitteri.it/en/news/20356/opus-5-5-nerfed-users-report-quality-drop)) |
| Sep 25 to Oct 1 | modelsentiment.com (Reddit mood, not a benchmark) | Sentiment 71 to 73, then 58, then 55 | Secondary (same, and [Admix, Oct 3](https://admix.software/blog/claude-opus-5-5-nerf-reports)) |
| Oct 20 | X | Viral "Opus 5.5 just got nerfed" post, 700,000+ views. Its screenshot was a usage panel (session 95%, weekly 41%), so it was about limits. | Secondary ([LaoZhang, Oct 21](https://blog.laozhang.ai/en/posts/claude-opus-5-5-nerfed)) |
| Oct 24 | X, [Thariq](https://x.com/trq212/status/2113848923945304528) | "wait is it just me or is Opus 5.5 dumber", 978K views. Context that blogs left out: it is a reply to a colleague, posted 19 minutes after [his own post](https://x.com/trq212/status/2113844051938054167) announcing he had left Anthropic's Claude Code team. It reads as a joke about his leaving, and it is not a bug report. Do not present it as an insider confirming a regression. | Direct |
| Oct 26 | Hacker News [50238759](https://news.ycombinator.com/item?id=50238759) | "Has Opus 5.5 gotten dumber for anyone else in the last few days?" 5 points | Direct |
| Oct 27 | GitHub [#105477](https://github.com/anthropics/claude-code/issues/105477) | Max 20x user: ignores loaded rules and skills, takes unauthorised actions, regressed "since the week of Oct 19". 17 reactions, 4 comments (three more users agreeing, Nov 2 to 4). Open, no Anthropic reply. | Direct |
| Oct 29 | Hacker News [50296367](https://news.ycombinator.com/item?id=50296367) | "Ask HN: Opus 5.5 suddenly dumb as rocks?" 37 points, 32 comments | Direct |

Usage-limit complaints are bigger than the quality ones on GitHub (all direct, all open, no Anthropic staff reply found):
- [#97074](https://github.com/anthropics/claude-code/issues/97074), Sep 25: headless `claude -p` uses about 1.8x more of the 5-hour window. 177 reactions.
- [#103376](https://github.com/anthropics/claude-code/issues/103376), Oct 19: weekly limit 0% to 54% in 22 hours. 16 reactions.
- [#105125](https://github.com/anthropics/claude-code/issues/105125), Oct 26: limits draining about 5x faster. 15 reactions.

Scale check (direct): issues labelled `area:model` ran at about 46 a day from Sep 22 to Oct 18 (1,250) and about 45 a day from Oct 19 to Nov 5 (773). There is no spike in that label after Oct 19. Labels are applied by triage, so this is a rough signal only.

## 2. What the measurements show

| Tracker | Latest reading | Result | Read |
|---|---|---|---|
| [LiveNerf](https://github.com/ninjahawk/livenerf) (pre-registered, daily since Sep 24, fixed prompts, pinned CLI 2.1.280) | Nov 4, day 42 | Window 1 (from Oct 4) +0.007 ± 0.018; window 2 (from Oct 14) -0.015 ± 0.018; window 3 (from Oct 24) +0.028 ± 0.023. All "no change". | Direct |
| [AI Stupid Level](https://aistupidlevel.info/) | Oct 6 to Nov 5 | Opus 5.5 ranked first on its 30-day coding board, score 97, no drift alarm | Direct |
| BridgeBench NerfBench | Oct 16 | 100.0 (Sep 22), 94.2 (Oct 2), 105.8 (Oct 16). The Oct 2 dip was the source of "-5.8%" posts and sat inside its normal band. | Secondary (CellCog, LaoZhang); site returned HTTP 402 |
| [Marginlab](https://marginlab.ai/trackers/claude-code/) | Sep 29 | Stale: detection paused since launch baseline | Direct |

Limits of these trackers, which the video must state:
- LiveNerf pins an old CLI (2.1.280) and uses exam-style questions (GPQA Diamond, MMLU-Pro, competition math). It would not catch a change in agent behaviour such as rule-following in long Claude Code sessions, which is what #105477 describes, or anything caused by newer CLI versions.
- It can only detect a shift of about 6.6 points per 10-day window. Its own validation could not tell Opus 5 from Opus 5.5 at 99% confidence, so a small change could hide.
- It did show that effort matters: `medium` scored 4.2 ± 3.9 points lower than its test setting with 26% fewer output tokens, and `low` 8.3 ± 4.5 lower.

## 3. What Anthropic has said

**Nothing official about an Opus 5.5 quality regression.** Checked directly on Nov 5:
- [Engineering blog](https://www.anthropic.com/engineering): the only post from September to November is about source control (Oct 13). The latest quality postmortem is from Apr 23, 2026, about earlier models.
- [Release notes](https://support.claude.com/en/articles/12138966-release-notes): nothing after Oct 21, nothing on quality, effort or limits.
- [Status page](https://status.claude.com/history): two Opus 5.5 incidents, both short "elevated errors" (Oct 6, 19 minutes; Oct 24, 6 minutes). These are failed requests, not worse answers. Other models had error windows on Oct 23 to 27.
- GitHub: no Anthropic staff comment on #105477 or the three limits issues.

The closest thing to a response (direct): Boris Cherny of Anthropic [replied to one user on X](https://x.com/bcherny/status/2109426207658066360) (Oct 12, 4:59 AM local; 61K views): "no changes on our end", with a command to dump usage history so he could help debug. It answers a usage-limit complaint, and it is a reply to one person, not a company statement on quality.

**Confirmed by Anthropic's own pages (direct):**
- Opus 5.5 launched Sep 22, 2026 ([announcement](https://www.anthropic.com/news/claude-opus-5-5)).
- Its default effort is `medium`, while older models default to `high` ([Claude Code model config](https://code.claude.com/docs/en/model-config); the announcement also says "default effort (medium)"). The headline benchmarks were run at max effort.
- Anthropic's stated reason for the medium default, which the video must include to be fair: "In Anthropic's testing, Opus 5.5 at `medium` matches or exceeds Opus 5 at `high` on coding and knowledge-work evaluations", and it advises starting at `medium` when moving from Opus 5 (same model config page, read as raw text on Nov 5). This is Anthropic's own claim; I found no independent check of it.
- It has safety classifiers that re-run flagged requests on another model: cybersecurity-flagged ones on Opus 4.8, biology-flagged ones on Opus 5. The announcement says these "fall back to another model transparently".
- The safety checks read everything the model reads, including memory, connector content, web results and files, so a flag can come from something other than your message. Switching is on by default and can be turned off in Settings ([help article, Sep 28](https://support.claude.com/en/articles/15363606), written for Fable; a [matching article for Opus 5 and 5.5](https://support.claude.com/en/articles/16049681-why-claude-switched-models-in-your-conversation-with-opus-5-or-opus-5-5) exists and I have not read it).
- Past precedent, read directly: Anthropic's [Apr 23, 2026 postmortem](https://www.anthropic.com/engineering/april-23-postmortem) found that earlier "Claude got worse" reports were real and had three causes in Claude Code, none in the model: the default effort was lowered from high to medium (Mar 4, reverted Apr 7, "the wrong tradeoff"), a bug dropped the model's earlier thinking every turn (fixed Apr 10), and a system prompt change hurt coding quality (reverted Apr 20). It says "We never intentionally degrade our models" and that the API was unaffected. It covers Sonnet 4.6 and Opus 4.6, not Opus 5.5. A September 2025 postmortem (secondary) admitted infrastructure bugs degraded answers.

### 3a. Things that did change around Opus 5.5 (all confirmed, all direct)

None of these is "the model was weakened", but each can change what users see.

1. **Saved effort settings did not carry over.** Claude Code 2.1.280 changelog: an effort level saved earlier "no longer appl[ies] to newly released models such as Opus 5.5; they start at their default until you pick a level". Anyone who had set `high` before got `medium` on Opus 5.5 until they chose again.
2. **Claude Code bugs that look like a dumber model were fixed after launch.** Changelog: 2.1.282, 2.1.287, 2.1.288 and 2.1.290 fixed cases where the model's earlier thinking was dropped; 2.1.293 fixed Claude "retracting or redoing finished work" after a context compaction. The changelog has no dates. 2.1.318 removed the 2.1.288 fix for old resumed conversations ("that thinking can now be dropped").
3. **Anthropic changed Claude Code's prompt on Opus 5.5 in late October.** Addy Osmani of Anthropic said on X that "We added two sentences to Claude Code's prompt on Opus 5.5 to steer it away from recreating someone else's specific game", quoted by [Tom's Hardware, Nov 2](https://www.tomshardware.com/tech-industry/artificial-intelligence/anthropic-confirms-new-claude-code-limits-to-prevent-game-cloning-users-report-opus-5-5-is-also-actively-blocking-reverse-engineering-tasks). Users report it began around Oct 27 and blocks legitimate game work ([#106167](https://github.com/anthropics/claude-code/issues/106167), Oct 30, 11 reactions, 14 comments). The timing overlaps the Oct 26 to 27 complaints, but nothing shows it caused the rule-following problems in #105477.

## 4. Confirmed versus anecdote

| Claim | Status |
|---|---|
| Many users report worse results since launch, most loudly from Oct 19 | Confirmed that the reports exist |
| Anthropic weakened the model | Not shown. No public evidence; the tracker built for it says no change. |
| Benchmarks dropped | No. One dip on Oct 2 was inside normal variance and recovered. |
| Default effort is medium, lower than older models' default | Confirmed (Anthropic docs) |
| Some requests are answered by an older model | Confirmed (Anthropic docs), only for flagged requests |
| Limits drain faster | Many reports, no official confirmation or explanation |
| Rule-following got worse in long agent sessions | Anecdote. Nobody has published a matched before/after test, and existing trackers don't measure it. |
| Saved "high" effort silently became medium on Opus 5.5 | Confirmed (Claude Code changelog 2.1.280) |
| Claude Code had bugs that dropped thinking or redid finished work | Confirmed and fixed (changelog 2.1.282 to 2.1.293) |
| Anthropic changed Opus 5.5's instructions after launch | Confirmed for one case: the game-cloning rule in Claude Code, late October |
| An Anthropic insider said it got dumber | Misread. The post is a former employee's reply in his own farewell thread. |
| Anthropic has responded | No official statement. One engineer's reply about limits ("no changes on our end", Oct 12) and one about the game rule. |

## 5. Demand (YouTube, India, logged out, last month by views)

Raw: `research/yt-demand-2026-11-05.txt`. Views are a stand-in for demand, not search volume.

- **English, this topic: modest.** "Do Claude and GPT Get Nerfed After Launch? We Have Proof Now" (Devsplainers) 57K; a similar video 16K; "Claude Opus 5.5 now uses 17% more" 5K; everything else under 3K. Autocomplete does offer "opus 5.5 nerfed" and "claude opus 5.5 nerfed".
- **Tamil, this topic: none.** "claude nerfed tamil" returned zero results. That means no competition, and also no proof anyone searches for it.
- **Tamil, Claude in general: strong.** A Tamil Claude Code tutorial has 122K. Autocomplete offers "claude limit reached tamil", "claude tamil tutorial" and "claude code tamil". Many "Tamil" results are English videos with auto-translated titles, so true Tamil supply is thinner than the list looks.
- **Limits beat quality.** "Claude usage limit" videos reach 200K to 950K, mostly "free" or "unlimited" angles.
- The peak of the nerf conversation was Oct 1 to 3 and Oct 20 to 29, so the topic is one to two weeks past its high point.
