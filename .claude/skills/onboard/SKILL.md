---
name: onboard
description: First-time setup — welcome the user, explain Virgil, collect basic config, then chain to each active workflow's onboarding.
---

This skill runs on first install. It establishes the basics of who the user is and how Virgil will operate for them, then hands off to each active workflow's own onboarding for workflow-specific configuration.

## When to run

- On first install — typically the user runs `/onboard` after cloning + copying `.example` templates.
- If the agent detects placeholders in `config/user.md` (`[Your name]`, `[/absolute/path/to/your/vault/]`, etc.), suggest running `/onboard` before any other interaction.

## Tone

Conversational, not bureaucratic. One question at a time. Show, don't just instruct. The user should feel a person guiding them, not a form being filled.

## Steps

### 1. Welcome + conceptual explanation

Open with a brief (≤ 8 lines) overview:

- Who Virgil is (an opinionated personal-OS agent)
- The core idea: **capture everything → label → route to the right place → close the day cleanly**
- The image concept: Virgil writes to a set of *destinations* (a vault, a task manager, etc.) — what those destinations are is your choice
- That workflows are the products inside Virgil — the first one (Capture & Route) is built-in; more will graduate from community contributions over time
- That this onboarding takes ~10 minutes; the rest of the setup is workflow-specific

End the welcome with: *"Ready to get started? I'll ask a few questions."*

Wait for confirmation.

### 2. Basic identity → `config/user.md`

Ask, one at a time:

- **Your name** — used in personalised responses, daily notes, and inter-agent communication
- **Your vault path** — absolute path to a folder (typically Obsidian-compatible markdown) where Virgil will read/write the scratchpad, daily notes, archive, meetings
  - If unsure: suggest `~/Documents/Virgil-Vault` and offer to create it
  - Validate: the path must exist or be creatable

Write these to `config/user.md`, replacing the placeholders. Keep all the existing structure and comments — only fill the bracketed values.

### 3. Channels

Ask:

- **Are you running Virgil locally (TUI) only, or also via Telegram / another channel?**
- If TUI only → confirm and move on
- If multi-channel → point to docs (currently NanoClaw setup for Telegram; covered separately from this skill)

### 4. Active workflows — chain to each one's onboarding

Scan `workflows/*/workflow.json`. For each workflow with `category: "built-in"` (always active) OR with explicit user activation:

- Announce: *"Now setting up the **[workflow name]** workflow — [tagline]"*
- Read `workflows/<id>/onboarding.md` if it exists
- Execute its steps (the workflow's onboarding file is a sub-skill — follow its instructions)
- After completion, confirm: *"[workflow name] is configured."*

For v1.1, only Capture & Route is built-in. Its onboarding lives at `workflows/capture-and-route/onboarding.md`.

### 5. Verify

Run the soft-test:

```
bash scripts/soft-test.sh
```

Report results. If anything fails, point the user to the relevant fix (e.g., "your vault path isn't readable — check permissions") and offer to retry.

### 6. Close

Confirm setup is complete:

- Summarise what was configured (name, vault path, channels, workflows)
- Suggest the first action: *"Run `/start` to begin your first session. Throw items at me through the day; I'll route them. End the day with `/wrap-up`."*
- Point to `docs/WORKFLOWS.md` for browsing the workflow catalog

## Guidelines

- Never write a placeholder value (e.g., "your name" instead of asking). If the user skips a question, leave the placeholder and note "you can fill this in later in `config/user.md`."
- After every write to `config/user.md`, show the user what changed (one-line diff).
- Don't ask questions about features that aren't yet wired (e.g., don't ask about Progress Diary in onboarding until it's implemented).
- If the user gets stuck on a step, offer to skip and come back — onboarding shouldn't be a blocking quiz.
