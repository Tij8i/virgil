---
name: wrap-up
description: End-of-day wrap-up — close out the session and set up tomorrow
---

End-of-day wrap-up: catch anything that slipped through, close out the session cleanly, and set tomorrow up for success.

Before starting, read `config/memory.md` for the current labelling system, vault structure, and Notion integration details.

## Steps

### 1. Catch stragglers

- Check `Scratch_Pad/Scratch_Pad.md` for any unprocessed items in the **top section** (above the Processed separator).
- Check `Meetings/` for transcripts not yet summarised in today's daily note.
- If anything is found, process it using the full sync logic: segment, label, show the user, wait for confirmation, file to `Archive/`, interlink with related notes, route tasks to **Notion Task Planner** (Status: Inbox, Source: Virgil, with Archive-linked related notes in description), mark completed tasks as Done in Notion.
- If a Notion API call fails, write to `_notion_queue.md` as fallback.
- After confirmation, move processed items to the **Processed section** at the bottom of `Scratch_Pad.md` (most recent on top). Do NOT clear the scratch pad.
- If everything is already processed, confirm that and move on.

### 2. Check Today.md

- Read `Today.md` at the vault root.
- Note which items are completed (checked) and which are still pending (unchecked).
- Completed items from Today become daily wins.
- Uncompleted items get mentioned in the daily note as carry-overs.

### 3. Query Notion for today's activity

- Search Notion Task Planner for tasks with Source: Virgil created or modified today.
- This is the safety net — captures anything routed during the day that might not be in session memory.
- Also check for any tasks marked Done today to include in Daily Wins.

### 3b. Collect other agents' wins

- Query the **Agent Updates** database for entries posted today with **Target: PA** and **Type: Session Update**.
- These are updates from other agents (Architect, Scrum Master, MS Manager, etc.) posted during their session close.
- Extract wins and key decisions from each update.
- Include these in the Daily Wins section of the daily note, grouped by agent.
- If no Session Update entries exist for today, that's fine — it means no other agents were active or haven't closed their sessions yet.

### 4. Close out today's daily note

- Open or create `Daily Notes/YYYY-MM-DD.md` using today's date.
- Write or finalise the **curated daily narrative** using the full session context + Notion query results:
  - **Daily Wins** — lead with everything accomplished today. Include completions logged live during the session, items checked off in Today.md, tasks marked Done in Notion, **and wins from other agents collected in step 3b** (grouped by agent name). Make the wins visible and worth celebrating.
  - What themes dominated the day based on notes processed and labels assigned.
  - What areas got the most focus (business, creative, personal, etc.).
  - What tasks were added to Notion Inbox today.
  - Uncompleted items from `Today.md` — what's rolling to tomorrow.
  - A brief editorial take on the day — was it scattered or focused? Productive or exploratory?
- If a daily note already exists from an earlier session, weave the end-of-day perspective into it — don't overwrite, enrich it.
- Link to all relevant archived notes and tasks using `[[wikilinks]]`.

### 4b. Cycle-end performance reporting

**Only on the last day of the cycle (Sunday by default — confirm with user.md if the cycle boundary is configured otherwise).**

If today is not the last day of the cycle, skip this step.

Otherwise:

1. Invoke `/score` to compute `V` for the just-ending cycle. Read `config/routing-decisions.log` and `config/corrections.log` per the `/score` skill spec.
2. Append a `## Cycle Recap` section to today's daily note, immediately after the Daily Wins section. Format:

```
## Cycle Recap (Week YYYY-Www)

V = <N> items successfully put through.
Trend: <↑/↓/flat> vs previous cycle (V was <M>).   ← omit if baseline cycle (1 or 2)

<1-line diagnostic if any sub-metric is concerning, omit otherwise>

Reminder: V is the primary KPI per CONTRACT.md. Sunset to a quality KPI when V plateaus at a satisfactory level.
```

3. If the cycle is **cycle 1 or 2** (baseline), drop the trend line and replace with: `Baseline cycle (cycle <N> of 2 — no trend comparison yet).`

This ties the daily note to the performance contract per `CONTRACT.md`. The dashboard surface (`dashboard/index.html`) aggregates V values too — see step 4c below — but the daily note remains the canonical first-write surface.

### 4c. Update dashboard data

After step 4 (and after 4b if it ran), update `dashboard/dashboard-data.js` with the current state. This is the data file consumed by `dashboard/index.html`.

**Format**: a single JS assignment `window.__VIRGIL_DASHBOARD__ = { ... }`. Schema: see `dashboard/dashboard-data.example.js`.

**Every wrap-up**:
- Bump `last_updated` to now (ISO 8601 datetime), `cycle` to current ISO week.
- Recompute the 6 diagnostic objective KPIs from `config/routing-decisions.log`, `config/corrections.log`, the vault, and Notion queries. For each: `current` value + a `severity` of `good`/`warn`/`bad` based on whether it meets the target. Optional `note` if there's a one-line diagnostic worth surfacing (e.g., "2 tasks missing Area").
- Append today's session summary to `recent_sessions` at the top (`{date, summary, items_routed, items_corrected}`). Keep last 10 entries.
- Leave the 4 diagnostic judgment KPIs as `current: "needs review"` — these require manual periodic review by the user, not auto-computation.
- Populate `workflows.registered` by reading each `workflows/*/workflow.json` in the repo. For each: emit `{id, name, category, status, tagline, primary_metric}`. For the active `capture-and-route` workflow, set `primary_metric` to `{name: "V", value: <current V>, trend: <up/down/flat/baseline>}`. For non-active workflows, set `primary_metric: null`.

**At cycle end** (only when step 4b ran):
- Update `primary_kpi.current_value` with the newly computed V.
- Append `{cycle, value}` to `primary_kpi.history`.
- Set `is_baseline: true` if cycle index ≤ 2; else false.
- Update `trend` (`up`/`down`/`flat`) and `trend_label` (one-line, e.g. "↑ +3 vs prior cycle"). For baseline cycles, set `trend_label: "baseline cycle — no trend until cycle 3"`.
- Update `note` with a one-line diagnostic if relevant.

**Write atomically** — overwrite the entire file content (don't append). The user just opens `dashboard/index.html` in any browser to view.

If the file write fails (path missing, permissions), log to `_notion_queue.md` with prefix `[Dashboard write]` and continue.

### 5. Post daily recap to Notion

After finalising the daily note, post a copy to the **Agent Updates** database in Notion:
- **Title**: Short summary line of the day (e.g., "Mar 4 — ST outreach, MS content, Orchestrator design")
- **Source**: `Virgil`
- **Target**: `SM`
- **Type**: `Daily Recap`
- **Date**: Today's date
- **Page content**: The full daily recap text from the daily note

If the Notion API call fails, note it in `_notion_queue.md` with the label `[Agent Update]`.

### 6. Save context for tomorrow

- Write a brief dated entry to `config/memory.md` (in the Session Log section):
  - Key things that happened today worth remembering.
  - Anything the user specifically asked to remember.
  - Open threads or follow-ups for tomorrow's `/start`.
- Keep entries concise. Append — don't overwrite previous entries.

### 7. Labelling system check

- Based on today's activity, reflect on the labelling system.
- Suggest **one improvement** — the most pressing one noticed. Could be a new label, a split, a merge, or a clarification.
- If approved, update the labelling system in `config/memory.md`.

### 8. Session close banner

Display a short closing banner:

```
--- Session Closed | YYYY-MM-DD ---
Completed: X items (marked Done in Notion)
Ideas logged: Y notes (in Archive)
Tasks routed: Z items (to Notion Inbox)
Today remaining: N items
Daily note: Daily Notes/YYYY-MM-DD.md
---
```

Give a brief conversational recap (2-3 lines): what got done, what's carrying over, anything to be aware of tomorrow. Like a colleague saying "here's where we left off" before heading out.

## Guidelines

- This is the last pass of the day — be thorough but quick.
- If the Scratch Pad top section and Meetings are clean, say so and skip to step 2.
- Never delete or archive notes without the user's confirmation.
- The memory entry should be useful to `/start` tomorrow — write it with that in mind.
- The labelling improvement suggestion should be specific and actionable, not vague.
- Always interlink new notes with existing ones using `[[wikilinks]]`.
- Notion is the source of truth for task status — the daily note summarises, it doesn't duplicate the task list.
