# Virgil — Setup Guide

## What is Virgil?

Virgil is a personal OS agent — it captures everything you throw at it (tasks, ideas, observations, completions, kids notes, groceries) and routes each item to the right place. It runs daily via two commands: `/start` (open session) and `/wrap-up` (close day).

## Prerequisites

- An Obsidian vault (or any markdown-based note system)
- A Notion workspace with Task Planner and Agent Updates databases
- Claude Code (Phase 0) or NanoClaw (Phase 1+)
- An LLM API key (Claude recommended)

## Quick Start (Claude Code)

1. Clone this repo
2. Copy the templates:
   ```bash
   cp config/user.md.example config/user.md
   cp config/memory.md.example config/memory.md
   cp config/connectors.md.example config/connectors.md
   cp .mcp.json.example .mcp.json
   ```
3. Open Claude Code in this directory: `claude`
4. **Run `/onboard`** — Virgil walks you through configuring everything (identity, vault path, workflow-specific setup like Notion DB IDs). Takes ~10 minutes.
5. Run `/start` to begin your first session.

## Directory Structure

```
vigil/
├── CLAUDE.md              # Agent identity — loaded automatically
├── skills/                # Portable skill definitions (canonical)
│   ├── start/SKILL.md     # /start command
│   └── wrap-up/SKILL.md   # /wrap-up command
├── config/                # Instance config (personal, not published)
│   ├── user.md            # Your Notion IDs, people, areas
│   ├── memory.md          # Cross-session context
│   └── connectors.md      # Output routing bindings
└── docs/
    └── SETUP.md           # This file
```

## Customisation

- **Area detection**: Edit `config/user.md` Area Detection Rules to match your life domains
- **Labels**: Edit `config/memory.md` Labels section to match your note categories
- **Output routing**: Edit `config/connectors.md` to change where outputs go (Notion, email, WhatsApp, etc.)
- **People**: Add your contacts to `config/user.md` People section for auto-detection
