# Workflows

> A workflow is where Virgil creates value. Each workflow is a discrete product with a use case, a user journey, and an outcome.

## What is a workflow?

A workflow is a *product* shipped inside Virgil. It has:

- **A use case** — for whom, what problem it solves
- **A user journey** — what the user does, in order
- **An outcome** — what value the user gets
- **Metrics** — how to tell if it's working

Workflows are the answer to "what does Virgil actually do for me?"

By contrast, the things below are **supporting infrastructure** — they enable workflows, but they aren't where the value lives:

- Identity (who Virgil is)
- Modes (how Virgil behaves at any given moment — Workflow / Assist / Open)
- Channels (TUI, Telegram, scratchpad — where you talk to Virgil)
- Skills (invokable commands during a conversation — `/start`, `/correct`, etc.)
- Integrations (MCP servers connecting Virgil to your tools)
- Memory & state (logs, daily notes, scratchpad)
- Dashboard (visibility into all of the above)

A skill is a *capability*; a workflow is a *product*. A workflow is implemented using one or more skills.

## Categories

| Category | Description | Example |
|---|---|---|
| **built-in** | Ships with Virgil. Always active. The foundation. | `capture-and-route` |
| **optional** | Installed by the user. The contribution flywheel happens here. | `progress-diary` (designed, not yet implemented) |

## File layout

Each workflow lives under `workflows/<id>/`:

```
workflows/<id>/
├── workflow.json     # Metadata — required
└── README.md          # Product card — required
```

`workflow.json` schema:

```json
{
  "id": "string (lowercase-with-dashes)",
  "name": "string (human-readable)",
  "version": "semver",
  "category": "built-in | optional",
  "status": "active | designed_not_implemented | deprecated",
  "tagline": "one-line value prop",
  "for_whom": "who this is for, in plain language",
  "outcome": "what the user gets",
  "user_journey": ["step 1", "step 2", "..."],
  "skills": ["start", "wrap-up"],
  "metrics": {
    "primary": { "name": "V", "description": "..." },
    "diagnostic": ["capture_rate", "..."]
  },
  "triggers": ["on_demand | on_start | on_wrap_up | scheduled"],
  "dependencies": {
    "vault": "...",
    "task_manager": "...",
    "mcps": ["notion"]
  }
}
```

## Writing your own workflow

(Coming with v1.2 alongside the `/install` skill. For now, the format is documented above — you can write a workflow folder + propose it as a PR to this repo.)

The intended flow:

1. Create `workflows/<your-id>/workflow.json` + `README.md` locally
2. Add the skill(s) that implement the workflow under `skills/<command>/`
3. Test it on your own Virgil instance
4. When it's working and useful, open a PR to add it to the core catalog
5. Once merged, other users can `/install <your-id>` it

This is the **contribution flywheel**: every Virgil instance gets smarter because users build the workflows they need, and the best ones become part of the core.

## Catalog (today)

| Workflow | Category | Status |
|---|---|---|
| [Capture & Route](../workflows/capture-and-route/) | built-in | active |
| [Progress Diary](../workflows/progress-diary/) | optional | designed (v1.2) |

## Roadmap

- **v1.2**: `/install` skill — install optional workflows with one command. Progress Diary implementation.
- **v1.3**: Workflow-specific dashboards. Per-workflow contribution metrics.
- **Later**: Community-contributed workflow gallery on the marketing site.
