# Virgil

> Your opinionated personal AI coworker. One shape, infinitely yours.

Virgil is an **open-core personal-OS agent**. He captures everything you throw at him — tasks, ideas, observations, completions, notes, groceries — and routes each item to the right place. He runs daily via two commands: `/start` (open session) and `/wrap-up` (close day).

Unlike generic automation platforms (n8n, Zapier, CodeWords), Virgil has a strong opinion on *what* a personal-OS agent does. Unlike closed apps (ChatGPT, Notion AI), every Virgil instance is yours to extend.

## Quick start

See **[docs/SETUP.md](docs/SETUP.md)** for full setup instructions.

TL;DR:

```bash
git clone https://github.com/Tij8i/virgil.git
cd virgil
cp config/user.md.example config/user.md       # then edit
cp config/memory.md.example config/memory.md    # then edit
cp config/connectors.md.example config/connectors.md  # optional
cp .mcp.json.example .mcp.json                  # add your Notion token
claude                                          # opens Claude Code
> /start
```

## What's in this repo

```
virgil/
├── CLAUDE.md              # Agent identity — loaded automatically by Claude Code
├── CONTRACT.md            # Performance contract (V = items successfully put through / cycle)
├── workflows/             # The product catalog — what Virgil does for you
│   ├── capture-and-route/ # Built-in: turn messy inputs into a structured idea system
│   └── progress-diary/    # Optional (v1.2): keep a diary of progress toward what matters
├── skills/                # Invokable commands: /start, /wrap-up, /correct, /score
├── config/                # Your instance config (gitignored — use .example templates)
├── dashboard/             # Per-instance performance dashboard
│   ├── index.html         # Open in any browser to view your Virgil's metrics
│   └── dashboard-data.example.js  # Schema reference + first-run preview
├── docs/
│   ├── SETUP.md           # Full setup guide
│   ├── WORKFLOWS.md       # What a workflow is + how to write your own
│   └── OPTIMIZATION_FUNCTION_v1.md  # KPI spec, image formula
└── scripts/
    └── soft-test.sh       # Verify your install is working
```

## What Virgil does for you — workflows

A **workflow** is a product Virgil ships with a clear use case, user journey, and outcome. The value of Virgil lives in its workflows — everything else (channels, skills, integrations, dashboard) is supporting infrastructure.

| Workflow | Status |
|---|---|
| [**Capture & Route**](workflows/capture-and-route/) — turn messy inputs into a structured idea system | 🟢 Built-in, active |
| [**Progress Diary**](workflows/progress-diary/) — keep a coherent diary of progress | 🟡 Designed (v1.2) |

More workflows graduate into the core as users build and contribute them. See [docs/WORKFLOWS.md](docs/WORKFLOWS.md) for the format + how to write your own.

## Performance dashboard

Each Virgil instance ships with a self-hosted dashboard at `dashboard/index.html`. Open it in any browser to see:

- **Primary KPI (V)** — items successfully put through Virgil per cycle, with trend
- **Diagnostic KPIs** — capture rate, queue size, metadata completeness, archive linking, daily coverage, deduplication
- **Recent sessions** — last 10 wrap-ups
- **Workflows** — placeholder until v1.1 (workflow registry)

Data is written by `/wrap-up` to `dashboard/dashboard-data.js` (gitignored — per-instance). No server required.

## Dependencies

- A Claude subscription (Claude Code) — Virgil's reasoning runs on Claude.
- An Obsidian vault (or any markdown folder) — Virgil's data store.
- A Notion workspace with at least Task Planner + Agent Updates databases (default — swappable via `config/connectors.md`).
- macOS or Linux (Windows untested).

## Status

**v1 (alpha-friend)**: forkable repo + setup docs. Suitable for technical users willing to walk through setup.

**Roadmap (v1.1, days)**: per-instance dashboard, workflow registry, onboarding workflow, usage metrics.

**Roadmap (later)**: one-click install for non-technical users, hosted/paid version, contribution-flywheel governance.

## License

MIT — see [LICENSE](LICENSE).

## Acknowledgements

Designed and built by [Alessio Tixi](https://github.com/Tij8i) with Claude (Anthropic).
