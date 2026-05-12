---
name: start
description: Open a live working session — process scratch pad, check today, enter listening mode
---

Open a live working session: process what's accumulated, show the state of play, and enter listening mode for live input.

Before starting, read `config/memory.md` for context carried over from previous sessions, the labelling system, vault structure, and Notion integration details.

## Steps

### 1. Load context

- Read `config/memory.md` for follow-ups, reminders, goals, and context from the last session.
- Note anything flagged for today's `/start`.

### 2. Flush Notion queue

- Check `_notion_queue.md` at vault root for any tasks that failed to sync previously.
- If items exist, attempt to push each to Notion Task Planner.
- Remove successfully synced items from the queue. Report any remaining failures.

### 3. Process Scratch Pad

Run the full sync logic on `Scratch_Pad/Scratch_Pad.md` (and any additional files in `Scratch_Pad/`):

- Parse and segment each file — one note may contain multiple items.
- Label each segment using the labelling system in `config/memory.md`.
- Route each item:
  - **Tasks** → Create in **Notion Task Planner** with Status: Inbox, Source: Virgil, Area if detectable (see Area Detection Rules in user.md). Before creating, search Notion for similar titles — include potential duplicates in the confirmation summary. **Archive linking:** search `Archive/` for notes related to the task (by keywords, Area, context) and include related note names in the Notion task description.
  - **Completed Tasks** → Find in Notion Task Planner and mark Status → Done. Record as daily wins for the daily note.
  - **Goals** → Create in **Notion Goals & Projects** database.
  - **Groceries** → append to `Archive/Shopping list.md`.
  - **Kids notes** → individual atomic note in `Archive/` + link in child's index file.
  - **Everything else** → `Archive/` as atomic notes with `[[wikilinks]]` to related notes.
- Process `>> directives` as instructions.
- **Present the summary and wait for confirmation before making changes.**
- If a Notion API call fails, write the task to `_notion_queue.md` as fallback.
- After confirmation, move processed items from the **top section** of `Scratch_Pad.md` to the **Processed section** at the bottom (most recent on top). Do NOT clear the scratch pad.
- Delete any additional files in `Scratch_Pad/` (other than `Scratch_Pad.md`) after processing.

### 4. Check Today.md

- Read `Today.md` at the vault root.
- Show any pending (unchecked) items.
- If `Today.md` doesn't exist, note it and move on.

### 5. Check Meetings

- Check `Meetings/` for any files not yet summarised in a daily note.
- For each new transcript: summarise key points, extract action items, route tasks to **Notion Task Planner** (Status: Inbox, Source: Meeting).
- If nothing new, skip.

### 6. Session banner

Display a short banner:

```
--- Session Open | YYYY-MM-DD ---
Scratch Pad: X items processed
Notion queue: Y items flushed / Z failed
Today: N items pending
Meetings: M new transcripts
---
```

### 7. Enter listening mode

After the banner, signal that the session is now live:

> **Listening mode active.** Drop anything here — completions, ideas, tasks, observations. I'll handle routing.

From this point, every subsequent message in the conversation is treated as live input. Handle each message according to its type:

- **Completions** (e.g., "done with X", "finished Y") → Find task in Notion Task Planner, mark Status → Done. Log as a daily win for the daily note.
- **New tasks** (e.g., "need to do X", "add X to the list") → Create in **Notion Task Planner** (Status: Inbox, Source: Virgil, Area if detectable). Check for duplicates first. Search `Archive/` for related notes and include links in the task description.
- **Urgent tasks** → Create in Notion Task Planner + add to `Today.md`.
- **Ideas and thoughts** → Route to `Archive/` as atomic notes with labels and links. If the thought needs deeper processing (wild thoughts, business-connected ideas needing synthesis, reflections to groom), tag it as `coaching-queue: true` in frontmatter and sub-type it. These are queued for coaching agent processing, not just filed.
- **Observations** → Note for the daily note narrative.
- **Groceries** → Append to `Archive/Shopping list.md`.
- **Kids notes** → Atomic note in `Archive/` + child's index.
- **`>> directives`** → Process as instructions.

**Immediate persistence:** Every item processed in listening mode is **immediately appended** to `Daily Notes/YYYY-MM-DD.md` as a raw bullet (e.g., `- [HH:MM] Item description → routing`). This ensures nothing is lost if the session disconnects. During `/wrap-up`, the raw log is refined into a curated narrative.

If a Notion API call fails during listening mode, write to `_notion_queue.md` and notify the user briefly.

Responses in listening mode are **short and functional** — confirm what was routed, where it went, and move on. No long explanations. Think of it as a quick acknowledgement: "Got it — added to Notion Inbox" or "Marked as Done in Notion + logged as a win."

**Session recovery:** If the user reconnects after a session interruption, they do NOT need to re-run `/start`. They can resume listening mode by typing items directly or saying "listening mode". Read the daily note to restore context on what was already captured.

## Guidelines

- Keep everything conversational and concise — this opens a working session, not a report.
- Use the current date to judge urgency.
- If `config/memory.md` is empty, note it and ask the user to fill it in.
- **Do NOT suggest priorities or tell the user what to focus on** — present the state of things clearly so they can decide.
- Don't make changes to files without confirmation during the initial processing (steps 2-4). In listening mode, act on input directly — the live channel IS the confirmation.
- Always interlink new notes with existing ones using `[[wikilinks]]`.
- Follow the dual-link format for List Master Index: `[[Wikilink]] [↗](obsidian://...)`.
- **Do NOT set** Importance, Timeliness, Sprint, or Project on Notion tasks — that's the Scrum Master's job.
