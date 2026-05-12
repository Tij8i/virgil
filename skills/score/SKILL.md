---
name: score
description: Compute Virgil's primary KPI V for the current cycle, with optional diagnostic KPI breakdown.
---

# /score skill

Triggered by:
- `/score` — basic: V + 1-line trend + 1-line diagnostic if any sub-KPI is concerning
- `/score detailed` — full breakdown: V + every diagnostic KPI from `CONTRACT.md`
- `/score last` — same as `/score` but for the previous cycle
- `/score <YYYY-Www>` — score a specific past cycle (e.g., `/score 2026-W19`)

This skill computes the primary KPI `V = items_successfully_put_through_Virgil_per_cycle` per `CONTRACT.md` and `docs/OPTIMIZATION_FUNCTION_v1.md`.

## Cycle determination

Default cycle: the ISO 8601 week of the current timestamp (e.g., `2026-W19`). Mon–Sun.

User overrides: `last`, or explicit `YYYY-Www` argument.

## Computing V

### Step 1 — Read the routing-decision log

Read `config/routing-decisions.log` (JSONL, append-only). Filter to entries where `cycle` matches the target cycle.

`items_routed_in_cycle` = count of these entries.

If the log file doesn't exist, V = 0 and report "No routing data for this cycle yet — log file empty or missing."

### Step 2 — Read the corrections log

Read `config/corrections.log` (JSONL, append-only). Filter to entries where `cycle` matches the target cycle.

`corrections_in_cycle` = count of these entries.

If the file doesn't exist, treat as 0 corrections.

### Step 3 — Compute V

```
V = items_routed_in_cycle − corrections_in_cycle
```

Per the Medium definition (`CONTRACT.md`): a "successfully put through" item is captured + routed + no `/correct` fired against it.

**Limbo exclusion**: if a routing-decision entry has `destination` set to `"pending"` or similar limbo marker (e.g., when Virgil asked a clarifying question), exclude it from `items_routed_in_cycle`. Per Virgil's review (2026-05-08): pending items don't count toward V's denominator until resolved.

### Step 4 — Compute trend

If the target cycle is **cycle 1 or 2** (per the baseline labeling in `docs/OPTIMIZATION_FUNCTION_v1.md`), report **"baseline cycle — no trend comparison."** The first two cycles are calibration; trend reporting starts at cycle 3.

Otherwise, repeat steps 1-3 for the **previous cycle** and compare:
- `↑` if V increased ≥10%
- `↓` if V decreased ≥10%
- `flat` otherwise

### Step 5 — Report

#### Basic mode (`/score`)

```
V (cycle <YYYY-Www>) = <N> items successfully put through.
Trend: <↑/↓/flat> vs cycle <prev> (V was <M>).
[Optional 1-line diagnostic — see Step 6.]
```

For baseline cycles, drop the trend line and replace with `Trend: baseline cycle (cycle <N> of 2 — calibration phase, no trend comparison yet).`

#### Detailed mode (`/score detailed`)

After the basic report, append a breakdown of all diagnostic KPIs from `CONTRACT.md`:

**Objective KPIs** (auto-computable):
- Capture rate: `<routed>/<received>` = `<%>` (target 100%)
- Notion queue at last `/start`: `<line count of _notion_queue.md at most recent /start>` (target 0)
- Task metadata completeness: `<%>` of cycle's Tasks have Name + Status + Source + Area set (Notion query)
- Archive linking rate: `<%>` of cycle's Tasks with `## Related vault notes` in description (target ≥80%)
- Daily note coverage: `<days with note>/<active days in cycle>` = `<%>` (target 100%)
- Deduplication: `<count>` near-duplicate task titles in Inbox (target 0)

**Judgment-based KPIs** — list each with status `needs manual review by user/Architect`:
- Routing accuracy
- Enrichment quality
- Distillation quality
- Classification accuracy

#### Specific cycle mode (`/score 2026-Www`)

Same as basic but for the requested cycle. Trend compares to the cycle before that one. If the target cycle has no data, report `No data for cycle <YYYY-Www>.`

### Step 6 — Diagnostic flag (basic mode)

In basic mode, append a 1-line diagnostic if any of these is true:

- `corrections / items_routed > 20%` → `Diagnostic: high correction rate (<%>) — routing/sizing accuracy is dragging.`
- `items_routed < items_received * 0.9` → `Diagnostic: capture gap (<%>) — items dropped or stuck in limbo.`
- `_notion_queue.md` has >5 lines → `Diagnostic: Notion fallback queue building up (<N> items) — flush at next /start.`

If no diagnostic fires, omit the line entirely (don't say "all good" — silence is the signal).

## Output formatting

- Always Markdown
- Terminal-friendly (no fancy formatting that breaks in plain text)
- Basic mode: ≤5 lines
- Detailed mode: ≤30 lines
- Specific cycle mode: ≤8 lines

## What this skill does NOT do

- Does **not** compute weighted composites. V is unweighted; diagnostic KPIs are not blended in.
- Does **not** auto-correct anything. Reports findings; corrections are user-driven via `/correct`.
- Does **not** modify the source logs. Read-only on `routing-decisions.log` and `corrections.log`.
- Does **not** post to Agent Updates. That's `/wrap-up`'s job at cycle end.

## Reference

- `CONTRACT.md` — performance contract, V definition, commitments
- `docs/OPTIMIZATION_FUNCTION_v1.md` — full spec, image formula, sub-KPI definitions
- `skills/correct/SKILL.md` — produces corrections.log
- `skills/wrap-up/SKILL.md` — invokes `/score` at cycle end
