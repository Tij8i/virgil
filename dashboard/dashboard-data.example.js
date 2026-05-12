// Example dashboard data — overwritten by Virgil at /wrap-up.
// Shape: { agents: [ { id, name, last_updated, cycle, primary_kpi, diagnostic_*, recent_sessions, workflows } ] }
window.__VIRGIL_DASHBOARD__ = {
  schema_version: 1,
  is_example: true,
  agents: [
    {
      id: "virgil",
      name: "Virgil",
      last_updated: "2026-05-12T18:00:00Z",
      cycle: "2026-W20",
      primary_kpi: {
        name: "V",
        description: "items successfully put through per cycle",
        current_value: 14,
        is_baseline: true,
        trend: "flat",
        trend_label: "baseline cycle — no trend until cycle 3",
        history: [
          { cycle: "2026-W19", value: 11 },
          { cycle: "2026-W20", value: 14 }
        ],
        note: "Baseline cycle (2 of 2). Trend reporting starts cycle 3. Sample shows steady use — capture + routing working as expected."
      },
      diagnostic_objective: [
        { name: "Capture rate", target: "100%", current: "100%", severity: "good", note: "No items dropped this cycle." },
        { name: "Queue at /start", target: "0", current: "0", severity: "good" },
        { name: "Task metadata completeness", target: "100%", current: "92%", severity: "warn", note: "2 tasks missing Area — auto-detection rule may need refinement." },
        { name: "Archive linking rate", target: "≥80%", current: "85%", severity: "good" },
        { name: "Daily note coverage", target: "100%", current: "100%", severity: "good" },
        { name: "Deduplication", target: "0 dupes", current: "0", severity: "good" }
      ],
      diagnostic_judgment: [
        { name: "Routing accuracy", target: "High", current: "needs review" },
        { name: "Enrichment quality", target: "High", current: "needs review" },
        { name: "Distillation quality", target: "High", current: "needs review" },
        { name: "Classification accuracy", target: "High", current: "needs review" }
      ],
      recent_sessions: [
        { date: "2026-05-12", summary: "Routine capture day", items_routed: 4, items_corrected: 0 },
        { date: "2026-05-11", summary: "Mixed: 2 ideas, 1 list, 1 task", items_routed: 4, items_corrected: 0 },
        { date: "2026-05-10", summary: "Heavy reflection day", items_routed: 6, items_corrected: 1 }
      ],
      workflows: {
        registered: []
      }
    }
  ]
};
