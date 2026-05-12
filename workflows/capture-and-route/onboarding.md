# Capture & Route — Workflow Onboarding

This onboarding runs as part of `/onboard` (chained from the generic onboarding skill). It configures the Capture & Route workflow — specifically, where the workflow's outputs should land.

## Steps

### 1. Introduce the workflow

Briefly (≤ 4 lines):

- Capture & Route turns messy inputs into a structured idea system
- It needs to know where to put things: tasks, ideas, daily notes, recaps
- The setup takes ~5 minutes; you can change destinations later in `config/user.md` and `config/connectors.md`

### 2. The image — where do things live?

Ask the user one destination at a time. For each, present the choice with honest support tier:

#### Tasks

> Where do you want your tasks to live?
>
> - **Notion** (recommended — fully wired in v1.1)
> - **Other** (Todoist, Things, Airtable, Excel, file folder, …) — you'll need to wire your own adapter; the abstraction layer ships in v1.2

If **Notion**: continue to step 3 (Notion setup).
If **Other**: capture their choice in `config/user.md` Task Manager section as a free-text note, and flag: *"Capture & Route will fall back to writing tasks to `_notion_queue.md` in your vault until the v1.2 adapter for [their choice] is wired. You can still use other workflows that don't require a task manager."*

#### Ideas / archive

> Where do you want your ideas, notes, and archive?
>
> - **Local markdown folder** (default — your vault, configured already)
> - **Notion** (in addition to the vault — e.g., a "Raw Ideas" database)
> - **Other**

The vault default works for almost everyone. Confirm the user is OK with markdown-in-vault and move on. If they want a Notion Ideas DB too, capture it in step 3.

#### Daily note + recap

> Where do you want your daily note? (The narrative of what happened today, posted at /wrap-up.)
>
> - **Vault** (`Daily Notes/YYYY-MM-DD.md` — default)
> - **Notion + vault** (post a copy to an Agent Updates DB)
> - **Vault only**

Capture choice.

### 3. Notion setup (only if Notion was chosen above)

Walk through:

1. **Create a Notion integration** at `https://www.notion.so/profile/integrations`. Name it "Virgil" or similar. Capability: "Read content + Insert content + Update content."
2. **Copy the integration secret** — it starts with `ntn_`. This is the API token.
3. **Update `.mcp.json`**: copy `.mcp.json.example` to `.mcp.json` if you haven't, then replace `YOUR_NOTION_TOKEN_HERE` with the real secret.
4. **Share your databases with the integration**: for each Notion DB you want Virgil to write to (Task Planner, Agent Updates, Ideas, etc.), open the DB → top-right `…` menu → Connections → Add the "Virgil" integration. Otherwise Virgil sees a 404.
5. **Collect the DB IDs**: for each DB, the ID is the 32-character string in the URL. The data-source ID is found under the database's settings (or via the Notion MCP `API-retrieve-a-database`). Add them to `config/user.md` under the Databases table.

Test the connection: ask Virgil to query one DB via the MCP. If it returns data, Notion is wired.

### 4. Area detection rules

Ask:

> What domains / areas of your life should Virgil recognise from context? Examples: Work, Family, Home, Career, Personal, [your project name], …

For each area, ask for keywords / context cues that distinguish it. Write to `config/user.md` Area Detection Rules table.

Don't force completeness — 3-5 rules is enough to start. The user will add more over time.

### 5. People (optional)

Ask:

> Are there 3-5 people you mention often who Virgil should recognise? (Family members, key collaborators, kids — anyone whose name should auto-tag a note.)

Capture name + one-line context. Skip if the user doesn't have anything to add.

### 6. Confirm + smoke test

Summarise what was configured. Then suggest a smoke test:

> Throw me a simple test item: *"Buy milk."*
>
> I'll route it. If it lands as a task in your task manager (or queue file), the workflow is working.

If the test passes → confirm Capture & Route is configured.
If it fails → diagnose (most common: Notion integration not shared with the DB, or the wrong DB ID).

Return to the generic onboarding for the close.

## Notes

- The Notion-first framing here is honest about v1.1 reality. v1.2 makes this truly storage-agnostic via the abstraction layer (see `docs/WORKFLOWS.md` roadmap).
- Don't over-engineer the smoke test. One real item through one real channel is enough confidence to ship the user into actual use.
