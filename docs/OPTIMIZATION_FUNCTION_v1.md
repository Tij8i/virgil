# Virgil Optimization Function v1

**Date**: 2026-05-08
**Status**: First simple-formulation pass. Replaces v0 (over-engineered composite).

---

## Why this version

v0 attempted a weighted composite across 4 axes. The user rejected it as over-engineered: the resulting `V` was an abstract number with no concrete relation to anything observable. Per the user:

> *"The KPIs are useful for deeper analysis but the top level KPI, at this stage, should be something like items successfully put through Virgil. This measures primarily user's engagement, which reflects perceived usefulness. Once that is steady, we can start measuring something else as a primary KPI."*

This version implements that. Single primary KPI, no composite, diagnostic KPIs available on demand.

---

## Image

Virgil's *image* — the destinations he writes to — defines the boundary of measurement. The image evolves with routing-rule changes; the formula stays true.

```
image(Virgil) = vault[Archive/*]
              ∪ vault[Daily Notes/*]
              ∪ vault[Meetings/*]
              ∪ vault[Today.md]           (urgent items only)
              ∪ vault[Scratch_Pad.md]     (processed section)
              ∪ vault[_notion_queue.md]   (fallback queue)
              ∪ Idea_Graph[Concepts/*]
              ∪ NotionDB[Tasks]
              ∪ NotionDB[Goals]
              ∪ NotionDB[Ideas]
              ∪ NotionDB[Agent Updates]
```

---

## Primary KPI (the one Virgil optimizes for)

```
V = items_successfully_put_through_Virgil_per_cycle
```

**"Successfully put through" — Medium definition** (locked):
> *captured + routed + no `/correct` fired against it*

- **Cycle** = Mon–Sun calendar week.
- **Counted item** = any input that landed in an image destination AND wasn't subsequently corrected by user.
- **Failure cases (excluded from count)**:
  - Item dropped (capture failed)
  - Item landed in `_notion_queue.md` fallback and never got promoted
  - Item routed but user fired `/correct` against it
- **Limbo exclusion** (per Virgil's review 2026-05-08): when Virgil receives an ambiguous item and asks a clarifying question, the item is captured but not yet routed. Pending items are **excluded from V's denominator until resolved** — a wave of clarifying questions does not artificially inflate the denominator.
- **Low-confidence routing/sizing**: per `CONTRACT.md` § 5, Virgil leaves the size or destination field blank rather than guess. Items with blank size/destination at end of cycle count as routed (if they reached an image destination) but flagged for SM follow-up — not orphans, not misclassifications.

**Direction**: maximize. No fixed target initially — establish a baseline over 2-3 cycles, then set a target.

**Why this metric**: it measures engagement (the user is using Virgil enough to put items through), which proxies perceived usefulness. If V trends down, the user is disengaging. If V trends up and is stable, the product is working.

**Sunset condition**: when V is steady at a level the user is happy with, the primary KPI shifts to a quality-flavored one (likely `correctness` or `enrichment_quality`). v2 will redefine the primary.

---

## Diagnostic KPIs (exposed on demand, not weighted)

These are not part of `V`. They surface depth when Virgil is asked `/score detailed` (or equivalent). Useful for diagnosing *why* `V` moved in one direction or the other.

### Objectively measurable (auto-checked at `/start` or `/wrap-up`)

| KPI | Target | Measurement |
|-----|--------|-------------|
| Capture rate | 100% | routed items / input items — nothing dropped |
| Notion queue at `/start` | 0 | `_notion_queue.md` line count |
| Task metadata completeness | 100% | Tasks with Name + Status + Source + Area set |
| Archive linking rate | ≥80% | Tasks with related vault notes in description |
| Daily note coverage | 100% | Daily note exists for every session day |
| Deduplication | 0 dupes | Inbox tasks with near-identical titles |

### Judgment-based (periodic review by the user)

| KPI | Target | Measurement |
|-----|--------|-------------|
| Routing accuracy | High | Was each item sent to the right destination? |
| Enrichment quality | High | Are Archive links genuine, not forced? |
| Distillation quality | High | Are IdeaGraph concepts atomic and useful? |
| Classification accuracy | High | Right label, right area? |

---

## What Virgil does with this

1. **Self-report `V` at end of each cycle** in `/wrap-up` weekly recap, with one-line trend ("up from last week / down / flat").
2. **Expose diagnostic KPIs on demand** via `/score detailed` (or equivalent command — Virgil to define).
3. **No self-prioritization yet.** Future versions may delegate weighting decisions to Virgil; this version keeps that layer with the user.

---

## Implementation prerequisites

**Build order** (per Virgil's review 2026-05-08): routing-decision log first, then `/correct`, then `/score`. The log is the hard prerequisite — without it, `/correct` and `/score` have no data to work against.

| # | Prerequisite | Owner | Status |
|---|--------------|-------|--------|
| 1 | Routing-decision log (item ID → destination + reasoning) — append-only JSONL at `config/routing-decisions.log` | Virgil-side build | Not started — **build first** |
| 2 | `/correct` skill — flags item as misrouted/missized; logs to `config/corrections.log` | Virgil-side build | Not started |
| 3 | `/score` skill — computes V + optional diagnostic KPIs | Virgil-side build | Not started |
| 4 | `/wrap-up` extension — auto-reports V at cycle end (Sunday or last day of cycle) | Virgil-side build | Not started |
| 5 | Dashboard surface (track V over time, expose diagnostics) | Roadmap (v1.1) | Backlog item |
| 6 | Baseline for V — cycles 1-2 labeled explicitly "baseline / no trend comparison" | 2-3 cycles of measurement | Not started |

**Item ID scheme** (per Virgil's review): timestamp + short hash of item title. Simplest viable.

**Baseline labeling** (per Virgil's review): cycles 1-2 are baseline; `/score` reports raw count only, no `↑/↓` trend until cycle 3.

---

## Bind to the agent

This doc is the source-of-truth for v1. To make it operationally binding, Virgil's `CLAUDE.md` references it via the "Performance Accountability" section, which defines the `V` metric and reporting cadence. The agent reads this file at session start and reports `V` at cycle end.

---

*Versioning: bump to v2 when the primary KPI shifts (per the sunset condition above) or when delegated-prioritization becomes viable. Don't edit v1 retroactively — preserve history.*
