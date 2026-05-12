# Capture & Route

> Turn messy inputs into a structured idea system.

**Status**: Built-in · Active by default
**Skills**: `/start` · `/wrap-up` · `/correct` · `/score`

## For whom

Anyone with too many inputs and not enough structure — thinkers, builders, parents, operators. People whose ideas, tasks, observations, and completions used to live across scattered notes, scraps of paper, and unfiled Slack messages.

## What it does

Capture & Route is Virgil's foundational workflow. You throw items at Virgil from anywhere — TUI, Telegram, a scratchpad file — and each item lands in the right place:

- Tasks → your task manager (Notion by default), with Status: Inbox, Source: Virgil
- Ideas / writings → your knowledge archive, as atomic notes, optionally linked to a concept graph
- Completions → marked Done, logged as daily wins
- Kids notes, groceries, meetings — each routed per your configured rules

Nothing dropped. Nothing lost. Nothing requires you to "process" your scratchpad — Virgil does it.

## User journey

1. **During the day** — throw items at Virgil through any channel
2. **Virgil labels and routes** — each item lands in its destination, with a one-line acknowledgement
3. **End of day** — run `/wrap-up`. Catches stragglers, finalises the daily note, posts a recap
4. **End of cycle** (weekly) — Virgil reports `V`, your primary KPI: items successfully put through

## Outcome

Every input lands in the right place. Your task manager stops being a graveyard of half-captured ideas. Your knowledge archive grows organically. Your daily log becomes a record of what you actually did, not what you intended.

You stop being the bottleneck between thought and structure.

## Metrics

This workflow is the source of Virgil's primary KPI `V` — items successfully put through per cycle. See `CONTRACT.md` for the full performance contract.

Diagnostic KPIs tracked:
- Capture rate (target 100%)
- Notion queue at /start (target 0)
- Task metadata completeness (target 100%)
- Archive linking rate (target ≥80%)
- Daily note coverage (target 100%)
- Deduplication (target 0 dupes)

All visible in `dashboard/index.html`.

## Dependencies

- An Obsidian-compatible vault (any markdown folder works)
- A task manager with an API (Notion by default — see `config/connectors.md.example` to swap)
- Notion MCP configured in `.mcp.json` (or alternative integration)

## How to disable

Capture & Route is the foundation — disabling it means Virgil has no value-creating workflow. We recommend keeping it active. To pause, simply don't run `/start`.
