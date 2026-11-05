# RUNLOG: the on-screen test (medium vs high effort on Claude Opus 5.5)

Honesty record for the test shown in beat S07 and the Short. Everything here was really run; raw CLI responses are kept in the video project's raw folder (not included here).

## What the test is, and is not

- **Is:** the same 12 prompts, each run 3 times at `--effort medium` and 3 times at `--effort high`, on `claude-opus-5-5`, headless, with no tools, on one day. It shows what the effort dial does on these prompts.
- **Is not:** a before/after test. We have no launch-week runs of our own, so it says nothing about whether the model changed since September 22. The video says this out loud.
- **Sample size:** 36 runs per setting. Differences of a few correct answers are inside noise. LiveNerf's published effort validation (medium −4.2 ± 3.9 points, 26% fewer output tokens, on 780-sample windows) is the better-powered number; ours is an illustration.

## Setup (2026-11-05)

- Machine: a Windows 11 laptop, Claude Code CLI 2.1.318, logged in with a Claude subscription account, so the runs count against the plan's usage.
- Command per call (prompt on stdin, run from an empty temp directory so no CLAUDE.md or project settings load):
  `claude -p --model claude-opus-5-5 --effort <medium|high> --tools "" --setting-sources project --strict-mcp-config --no-session-persistence --disable-slash-commands --output-format json`
- The CLI's own system prompt still applies; it is the same for both settings. Thinking cannot be turned off on Opus 5.5.
- Each prompt ends with: "You have no tools and cannot run code. Work it out yourself. End your reply with one final line in exactly this form: ANSWER: <value>".
- Grading: exact match of the `ANSWER:` line against a value computed by `effort-test/effort_test.py` itself (brute force or closed form in Python), never by a model. Whitespace, commas and underscores are ignored.
- The JSON result of every call records which model answered (`modelUsage`), output tokens, wall time and API-equivalent cost.
- Script: `effort-test/effort_test.py` (`truth`, `pilot`, `run 3 3`, `report`). Questions and ground truth: `effort-test/questions.json`. Table: `effort-test/RESULTS.md`.

## Questions (ground truth in brackets)

1. digitsum: integers 1..1,000,000 with digit sum 20 [35127]
2. domino: domino tilings of a 3 x 12 rectangle [2131]
3. product: 987654321 x 123456789 [121932631112635269]
4. twins: primes p < 10,000 with p + 2 prime [205]
5. python: output of a short program with a mutable default argument and late-binding lambdas ["40 3"]
6. letters: count of the letter e in a given sentence [67]
7. perms: permutations of 8 with no fixed points and no 2-cycles [8988]
8. squares: smallest n > 2000 that is a^2 + b^2 (0 < a <= b) in exactly 3 ways [2050]
9. knight: shortest knight path a1 to h8 with 10 blocked squares [6]
10. josephus: Josephus problem, n = 1000, k = 7 [404]
11. bits: binary strings of length 20 with no 000 or 111 [21892]
12. pow2: digit sum of 2^200 [256]

## Pilot (2026-11-05, question 1 only, one call per setting)

Both correct. medium: 371 output tokens, 9.8 s. high: 538 output tokens, 9.0 s. The CLI reported `thinking_tokens: 0` for both, so the output-token figure may not include adaptive thinking; treat token counts as the CLI reports them, not as a full measure of reasoning. Pilot files are `*__r0.json` and are excluded from the results table.

## Results

Run on 2026-11-05 (72 calls, 3 workers in parallel, about 10 minutes). Every answer came back from `claude-opus-5-5` (no fallback model appeared in `modelUsage`).

- **medium:** 36/36 correct. Median 586 output tokens and 11.6 s per answer; 33,915 output tokens in all.
- **high:** 36/36 correct. Median 722 output tokens and 12.9 s per answer; 39,799 output tokens in all.
- High used about 17% more output tokens in total (23% more at the median) and about 11% more time at the median.

Reading: on these 12 questions the effort setting made no difference to correctness; both settings were at the ceiling, so this test cannot show an accuracy gap and the video does not claim one. It shows that `high` spends more tokens and time on the same prompts. The ceiling is the main weakness of the question set: harder tasks would be needed to see what LiveNerf's panel saw (medium −4.2 ± 3.9 points). Token counts are as the CLI reports them (`thinking_tokens` showed 0 throughout).

What the video says about it (S07 and the Short): both 36/36; high wrote about twenty percent more tokens and took a little longer; on questions like these medium is already enough; the effort gap shows on harder work, citing LiveNerf; one day, one machine, 36 runs per setting; not a before/after test.

Full table (`effort-test/RESULTS.md`):


- **medium**: 36/36 correct, 33,915 output tokens, 524 s total wall time, $1.11 API-equivalent cost
- **high**: 36/36 correct, 39,799 output tokens, 617 s total wall time, $1.02 API-equivalent cost
- Models that answered (from the CLI's modelUsage): ['claude-opus-5-5']

| Question | Truth | medium: correct / runs, median out tokens, median s | high: correct / runs, median out tokens, median s |
|---|---|---|---|
| digitsum | 35127 | 3/3, 340, 9.4 | 3/3, 452, 10.0 |
| domino | 2131 | 3/3, 566, 11.0 | 3/3, 669, 11.4 |
| product | 121932631112635269 | 3/3, 596, 10.0 | 3/3, 688, 10.5 |
| twins | 205 | 3/3, 422, 10.8 | 3/3, 698, 13.0 |
| python | 40 3 | 3/3, 381, 9.0 | 3/3, 408, 9.2 |
| letters | 67 | 3/3, 1161, 19.7 | 3/3, 1172, 18.0 |
| perms | 8988 | 3/3, 555, 11.6 | 3/3, 590, 12.2 |
| squares | 2050 | 3/3, 2237, 27.0 | 3/3, 2681, 39.3 |
| knight | 6 | 3/3, 1183, 16.5 | 3/3, 1282, 18.4 |
| josephus | 404 | 3/3, 2271, 24.8 | 3/3, 2418, 28.2 |
| bits | 21892 | 3/3, 482, 10.7 | 3/3, 430, 9.5 |
| pow2 | 256 | 3/3, 1009, 15.9 | 3/3, 1656, 19.8 |
