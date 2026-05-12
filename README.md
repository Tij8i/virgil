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
├── skills/                # /start, /wrap-up, /correct, /score
├── config/                # Your instance config (gitignored — use .example templates)
├── docs/
│   ├── SETUP.md           # Full setup guide
│   └── OPTIMIZATION_FUNCTION_v1.md  # KPI spec, image formula
└── scripts/
    └── soft-test.sh       # Verify your install is working
```

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
