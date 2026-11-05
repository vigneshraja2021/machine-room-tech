"""Real run: the same prompts on Claude Opus 5.5 at medium vs high effort, headless, no tools.

Usage:
  python tools/effort_test.py truth              # compute ground truth -> research/effort-test/questions.json
  python tools/effort_test.py pilot              # one call per effort on question 1, print the raw JSON keys
  python tools/effort_test.py run [runs=3] [workers=3]
  python tools/effort_test.py report             # table -> research/effort-test/RESULTS.md

Every raw CLI response is kept in research/effort-test/raw/. Answers are graded by exact match
against values computed by this script, never by a model.
"""
import itertools, json, os, re, shutil, subprocess, sys, tempfile, time
from collections import deque
from concurrent.futures import ThreadPoolExecutor
from math import isqrt
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OUT = ROOT / "research" / "effort-test"
RAW = OUT / "raw"
MODEL = "claude-opus-5-5"
EFFORTS = ["medium", "high"]
SUFFIX = ("\n\nYou have no tools and cannot run code. Work it out yourself. "
          "End your reply with one final line in exactly this form:\nANSWER: <value>")

PARA = ("Every evening the engineers gathered beside the generator shed, where sixteen green "
        "levers were kept freshly greased, and they debated whether the eleven emergency "
        "breakers needed replacement before the western feeder exceeded its expected seasonal peak.")

CODE = '''def make(n, acc=[]):
    acc.append(n)
    return [lambda x: x + i for i in range(n)], acc

total = 0
for k in (2, 3, 4):
    fs, acc = make(k)
    total += sum(f(len(acc)) for f in fs)
print(total, len(acc))'''

BLOCKED = ["b3", "d4", "e5", "f6", "c5", "f3", "e7", "g5", "e3", "d6"]


def digit_sum_count():
    return sum(1 for n in range(1, 1_000_001) if sum(map(int, str(n))) == 20)


def tilings_3xn(n):
    a, b = [1, 0], [0, 1]  # a[i] = full tilings of 3 x i ; standard recurrence f(n)=4f(n-2)-f(n-4)
    f = {0: 1, 2: 3}
    for i in range(4, n + 1, 2):
        f[i] = 4 * f[i - 2] - f.get(i - 4, 0)
    return f[n]


def twin_pairs(limit):
    s = bytearray([1]) * (limit + 3)
    s[0] = s[1] = 0
    for i in range(2, isqrt(limit + 2) + 1):
        if s[i]:
            s[i * i::i] = bytearray(len(s[i * i::i]))
    return sum(1 for p in range(2, limit) if s[p] and s[p + 2])


def code_output():
    import io, contextlib
    buf = io.StringIO()
    with contextlib.redirect_stdout(buf):
        exec(CODE, {})
    return buf.getvalue().strip()


def perms_no_1_2_cycles(n):
    c = 0
    for p in itertools.permutations(range(n)):
        if all(p[i] != i and p[p[i]] != i for i in range(n)):
            c += 1
    return c


def three_ways_two_squares(start):
    n = start
    while True:
        n += 1
        ways = sum(1 for a in range(1, isqrt(n // 2) + 1) if isqrt(n - a * a) ** 2 == n - a * a)
        if ways == 3:
            return n


def knight_path():
    sq = lambda s: (ord(s[0]) - 97, int(s[1]) - 1)
    blocked = {sq(s) for s in BLOCKED}
    start, goal = sq("a1"), sq("h8")
    seen, q = {start: 0}, deque([start])
    while q:
        x, y = q.popleft()
        if (x, y) == goal:
            return seen[(x, y)]
        for dx, dy in [(1, 2), (2, 1), (-1, 2), (-2, 1), (1, -2), (2, -1), (-1, -2), (-2, -1)]:
            p = (x + dx, y + dy)
            if 0 <= p[0] < 8 and 0 <= p[1] < 8 and p not in blocked and p not in seen:
                seen[p] = seen[(x, y)] + 1
                q.append(p)
    return -1


def josephus(n, k):
    r = 0
    for i in range(2, n + 1):
        r = (r + k) % i
    return r + 1


def no_three_equal(n):
    return sum(1 for b in range(1 << n) if not re.search(r"000|111", format(b, f"0{n}b")))


def collatz_steps(n):
    c = 0
    while n != 1:
        n = n // 2 if n % 2 == 0 else 3 * n + 1
        c += 1
    return c


def questions():
    q = [
        ("digitsum", "How many integers n with 1 <= n <= 1,000,000 have a digit sum of exactly 20?", digit_sum_count()),
        ("domino", "In how many ways can a 3 x 12 rectangle be tiled with 1 x 2 dominoes?", tilings_3xn(12)),
        ("product", "What is 987654321 x 123456789? Give the exact integer.", 987654321 * 123456789),
        ("twins", "How many primes p < 10,000 are there such that p + 2 is also prime?", twin_pairs(10_000)),
        ("python", "What exactly does this Python 3 program print?\n\n" + CODE, code_output()),
        ("letters", "How many times does the letter e (upper or lower case) appear in this sentence?\n\n" + PARA, PARA.lower().count("e")),
        ("perms", "How many permutations of {1,...,8} have no fixed points and no 2-cycles?", perms_no_1_2_cycles(8)),
        ("squares", "What is the smallest integer n > 2000 that can be written as a^2 + b^2 with positive integers a <= b in exactly 3 different ways?", three_ways_two_squares(2000)),
        ("knight", "A chess knight starts on a1 and must reach h8 on a standard 8x8 board. These squares are blocked and cannot be landed on: " + ", ".join(BLOCKED) + ". What is the minimum number of moves?", knight_path()),
        ("josephus", "1000 people stand in a circle, numbered 1 to 1000. Starting the count at person 1, every 7th person is removed, and counting continues from the next person. What is the number of the last person left?", josephus(1000, 7)),
        ("bits", "How many binary strings of length 20 contain no three consecutive equal bits (neither 000 nor 111)?", no_three_equal(20)),
        ("pow2", "What is the sum of the decimal digits of 2^200?", sum(map(int, str(2 ** 200)))),
    ]
    return [{"id": i, "prompt": p, "answer": str(a)} for i, p, a in q]


def norm(s):
    return re.sub(r"[\s,_`*]", "", s or "").lower()


def extract(text):
    m = re.findall(r"ANSWER:\s*(.+)", text or "")
    return m[-1].strip() if m else None


def call(q, effort, run, workdir):
    out = RAW / f"{q['id']}__{effort}__r{run}.json"
    if out.exists():
        return json.loads(out.read_text(encoding="utf-8"))
    cmd = [shutil.which("claude"), "-p", "--model", MODEL, "--effort", effort, "--tools", "",
           "--setting-sources", "project", "--strict-mcp-config", "--no-session-persistence",
           "--disable-slash-commands", "--output-format", "json"]
    t0 = time.time()
    p = subprocess.run(cmd, input=q["prompt"] + SUFFIX, capture_output=True, text=True,
                       encoding="utf-8", cwd=workdir, timeout=1800)
    rec = {"id": q["id"], "effort": effort, "run": run, "started_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime(t0)),
           "wall_s": round(time.time() - t0, 1), "cmd": " ".join(cmd[1:]), "returncode": p.returncode, "stderr": p.stderr[-500:]}
    try:
        rec["cli"] = json.loads(p.stdout)
    except Exception:
        rec["cli"] = {"unparsed": p.stdout[-2000:]}
    text = rec["cli"].get("result") if isinstance(rec["cli"], dict) else None
    rec["got"] = extract(text)
    rec["correct"] = rec["got"] is not None and norm(rec["got"]) == norm(q["answer"])
    out.write_text(json.dumps(rec, indent=1, ensure_ascii=False), encoding="utf-8")
    return rec


def main():
    sys.stdout.reconfigure(encoding="utf-8")
    mode = sys.argv[1] if len(sys.argv) > 1 else "report"
    RAW.mkdir(parents=True, exist_ok=True)
    qfile = OUT / "questions.json"
    if mode == "truth":
        qs = questions()
        qfile.write_text(json.dumps(qs, indent=1, ensure_ascii=False), encoding="utf-8")
        for q in qs:
            print(q["id"], "=", q["answer"])
        return
    qs = json.loads(qfile.read_text(encoding="utf-8"))
    workdir = tempfile.mkdtemp(prefix="effort-test-")
    if mode == "pilot":
        for e in EFFORTS:
            r = call(qs[0], e, 0, workdir)
            c = r["cli"]
            print(e, "rc", r["returncode"], "got", r["got"], "correct", r["correct"], "wall", r["wall_s"])
            print("  keys:", list(c.keys()) if isinstance(c, dict) else c)
            print("  usage:", json.dumps(c.get("usage"))[:400], "| modelUsage:", json.dumps(c.get("modelUsage"))[:600])
            print("  stderr:", r["stderr"][:300])
        return
    if mode == "run":
        runs = int(sys.argv[2]) if len(sys.argv) > 2 else 3
        workers = int(sys.argv[3]) if len(sys.argv) > 3 else 3
        jobs = [(q, e, r) for r in range(1, runs + 1) for q in qs for e in EFFORTS]
        with ThreadPoolExecutor(workers) as ex:
            for rec in ex.map(lambda j: call(j[0], j[1], j[2], workdir), jobs):
                print(rec["id"], rec["effort"], "r%d" % rec["run"], "OK" if rec["correct"] else "WRONG got=%s" % rec["got"], rec["wall_s"], "s", flush=True)
        return
    # report
    recs = [json.loads(p.read_text(encoding="utf-8")) for p in sorted(RAW.glob("*__r[1-9]*.json"))]
    lines = ["| Question | Truth | " + " | ".join(f"{e}: correct / runs, median out tokens, median s" for e in EFFORTS) + " |", "|---|---|---|---|"]
    tot = {e: [0, 0, 0, 0.0, 0.0] for e in EFFORTS}
    models = set()
    for q in qs:
        row = [q["id"], q["answer"][:28]]
        for e in EFFORTS:
            rs = [r for r in recs if r["id"] == q["id"] and r["effort"] == e]
            ok = sum(r["correct"] for r in rs)
            toks = sorted((r["cli"].get("usage") or {}).get("output_tokens", 0) for r in rs)
            secs = sorted(r["wall_s"] for r in rs)
            for r in rs:
                models.update((r["cli"].get("modelUsage") or {}).keys())
                tot[e][2] += (r["cli"].get("usage") or {}).get("output_tokens", 0)
                tot[e][3] += r["wall_s"]
                tot[e][4] += r["cli"].get("total_cost_usd") or 0
            tot[e][0] += ok
            tot[e][1] += len(rs)
            row.append(f"{ok}/{len(rs)}, {toks[len(toks)//2] if toks else '-'}, {secs[len(secs)//2] if secs else '-'}")
        lines.append("| " + " | ".join(row) + " |")
    summ = [f"- **{e}**: {t[0]}/{t[1]} correct, {t[2]:,} output tokens, {t[3]:.0f} s total wall time, ${t[4]:.2f} API-equivalent cost" for e, t in tot.items()]
    body = "# Effort test results\n\n" + "\n".join(summ) + f"\n- Models that answered (from the CLI's modelUsage): {sorted(models)}\n\n" + "\n".join(lines) + "\n"
    (OUT / "RESULTS.md").write_text(body, encoding="utf-8")
    print(body)


if __name__ == "__main__":
    main()
