# Virgil PA — Genus Manifest

Virgil is an open-core personal-OS agent: capture, route, and close the day cleanly across all the messy inputs of a personal productivity system. He runs on Claude Code, hosted on NanoClaw, gated by a nightly wrap-up cron.

This manifest declares Virgil PA's conformance to Genus v0.1 as a Virgil-archetype agent. Per [Genus](https://github.com/Tij8i/Genus) (the protocol), the manifest is the contract between the agent and the installation that hosts it.

```yaml
genus_version: "0.1"
archetype: "virgil"
name: "Virgil PA"
version: "1.1.0"
operator: "alessio@sensibleflow"
runtime: "claude_code"                              # Agent runtime
# Host orchestration: NanoClaw (provides container, Telegram bridge, scheduled-task service)

identity_files:
  identity: "CLAUDE.md"                             # Claude Code idiomatic identity surface
  contract: "CONTRACT.md"                           # Performance contract (V optimization function)
  playbook_workflows: "workflows/"                  # Folder of named workflows (capture-and-route, progress-diary)
  playbook_skills: "skills/"                        # Folder of invokable commands (/start, /wrap-up, /correct, /score, /onboard)
  domain_and_preferences: "config/user.md"          # Per-instance user config (vault path, area rules, channels)
  routing_decisions_log: "config/routing-decisions.log"   # Append-only per-decision JSONL — feeds V
  correction_log: "config/corrections.log"          # Operator corrections via /correct — feeds V
  memory_rules: "config/memory.md"                  # Knowledge distillation / IdeaGraph rules
  optimization_spec: "docs/OPTIMIZATION_FUNCTION_v1.md"   # Image formula + diagnostic KPI definitions

permissions:
  - "personal_data:notion_tasks"
  - "personal_data:notion_goals"
  - "personal_data:notion_ideas"
  - "personal_data:vault_files"                     # Obsidian vault (Archive/, Daily Notes/, Meetings/)
  - "personal_data:telegram_messages"
  - "write:agent_updates"
  - "connector:notion"
  - "connector:telegram"
  - "connector:obsidian_vault"                      # Local filesystem (the operator's vault)

connectors:
  - "notion"
  - "telegram"                                      # Inbound message bridge via NanoClaw
  - "obsidian_vault"                                # Local filesystem access

composability:
  standalone: true
  expects: ["genus>=0.1"]
  recommends: []                                    # Virgil is fully standalone; no companion agents required

repo_url: "https://github.com/Tij8i/virgil"
license: "MIT"

personal_domain: "general PA"

# Heartbeat: nightly wrap-up. Cron is hosted on NanoClaw (the host orchestration), not in
# Claude Code's native triggers. NanoClaw runs a small gating script first: if today's
# Daily Note already contains "Session Closed" or a "## Narrative" section, the gate
# returns wakeAgent:false and nothing happens. Otherwise NanoClaw wakes the agent and
# fires the /wrap-up skill.
heartbeat_schedule: "0 0 * * *"                     # 00:00 Europe/Rome — NanoClaw-hosted, gated by daily-note check
heartbeat_timezone: "Europe/Rome"

personal_data_scope:
  - "personal_data:notion_tasks"
  - "personal_data:notion_goals"
  - "personal_data:notion_ideas"
  - "personal_data:vault_files"
  - "personal_data:telegram_messages"

kpis:
  - { name: "V — items successfully put through per cycle", kpi_registry_ref: "virgil.V", cadence: "weekly" }

authority_envelope:
  default: "autonomous"
  workflows:
    - { workflow: "capture-and-route", level: "autonomous" }        # Routes inbox items without approval
    - { workflow: "progress-diary", level: "autonomous" }
    - { workflow: "skill:/start", level: "autonomous" }
    - { workflow: "skill:/wrap-up", level: "autonomous" }           # Posts daily recap to Agent Updates
    - { workflow: "skill:/correct", level: "autonomous" }
    - { workflow: "skill:/score", level: "autonomous" }
    - { workflow: "skill:/onboard", level: "approval" }             # First-time setup needs operator input
```

---

## About this manifest

Authored 2026-05-29 as part of the Genus Phase B retrofit — porting existing reference agents into Genus-conforming format. The Virgil archetype spec is still evolving; for the current protocol, see the [Genus repo](https://github.com/Tij8i/Genus).

**Notable Virgil-specific patterns** (worth documenting in future spec iterations):

- **Gated heartbeat** — the nightly cron checks whether today's work is already closed before waking the agent. Save compute + avoid noise on days when the operator already wrapped up themselves.
- **Continuous calibration via `/correct`** — instead of a bi-weekly Trust Cycle, Virgil takes operator corrections as they happen. Each `/correct` invocation feeds the V optimization function and influences future routing decisions.
- **Distributed equivalents of Stewart's "required files"** — Virgil's preferences, routing decisions, and corrections live in `config/` files rather than top-level `PREFERENCES.md` / `RECOMMENDATIONS.md` / `REFLECTION_LOG.md`. Same primitives, different file layout.

---

*v0.1 (2026-05-29) — initial Genus manifest. Source: `CLAUDE.md`, `CONTRACT.md`, `docs/OPTIMIZATION_FUNCTION_v1.md`, repo inspection, NanoClaw scheduled task `task-1778656631838-5jvarp`.*
