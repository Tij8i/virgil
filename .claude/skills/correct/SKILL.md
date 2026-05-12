---
name: correct
description: Flag a Virgil routing or sizing decision as wrong. Logs the correction so it feeds into V.
---

# /correct skill

Triggered when the user fires `/correct [item-reference] [reason]`. The reason is optional; item-reference defaults to "the most recently routed item."

This skill is the user's signal that Virgil's routing or sizing decision was wrong. It feeds the `V` denominator: a "successfully put through" item is one with **no** correction entry in the cycle (`CONTRACT.md` and `docs/OPTIMIZATION_FUNCTION_v1.md`).

## Behavior

### Step 1 — Identify the original item

Look at `config/routing-decisions.log` (append-only JSONL). Determine which item the user is correcting:

- If the user gave an explicit reference (e.g., `/correct task "Buy lightbulb"`), search the log for a recent entry with matching `input_text_excerpt`.
- If the user gave no reference (just `/correct`), default to the **most recent entry** in the log.
- If multiple plausible matches, ask the user to disambiguate before logging.
- If the original item can't be identified, do not guess — ask the user for more context.

### Step 2 — Log the correction

Append one JSON line to `config/corrections.log` (append-only JSONL):

```json
{"timestamp": "<ISO 8601>", "original_item_id": "<id from routing-decisions.log>", "original_destination": "<from log entry>", "original_size": "<from log entry, may be blank>", "original_reasoning": "<from log entry>", "user_feedback": "<reason from user, or empty string>", "cycle": "<YYYY-Www of current timestamp>"}
```

**Cycle** = ISO 8601 week of the current timestamp (e.g., `2026-W19`).

If `config/corrections.log` doesn't exist, create it. The file is append-only — never edit prior entries.

### Step 3 — Optional: act on the correction

If the user provided context for *what the correction should be* (e.g., "this should be a Project, not an Errand", or "route this to Goals DB instead of Tasks DB"), apply the change to the artifact:

- Update the Notion item (re-route, re-size, etc.)
- Update the vault file if affected (move, re-tag, re-link)
- The correction log entry stays — it's the audit trail; the artifact just reflects the corrected state.

If the user only flagged the error without specifying the fix, just log it. Don't guess at the fix.

### Step 4 — Acknowledge

Short response, no narrative:

> "Logged correction for [item]. [Optional: `Re-routed to <new destination>.` if applied.]"

## Notes

- **Append-only**: never edit prior entries in either log.
- **Identification rule**: when in doubt, ask. Don't log against the wrong item.
- **No retroactive cleanup**: a correction entry doesn't delete the original routing-decision entry. Both stay. `/score` reconciles them at compute time.
- **Cycle attribution**: a correction belongs to the cycle of the *correction timestamp*, not the cycle of the original routing. This means a correction fired Mon for a Sunday-routed item lands in the new week. That's intentional — corrections measure where Virgil's misfires hurt, not where they originated.

## Output contract

- `config/corrections.log` is the source of truth for misclassification data.
- `/score` reads this file (filtered by cycle) to compute `V`.
- Dashboard (when built) reads aggregates of this file.

## Reference

- `CONTRACT.md` — performance contract V binding
- `docs/OPTIMIZATION_FUNCTION_v1.md` — full V definition + cycle semantics
- `skills/score/SKILL.md` — consumer of corrections.log
