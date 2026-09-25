# DECISIONS LOG

Format: ID — date — decision — rationale — alternatives considered — reversibility.

- D-001 — 2026-09-25 — Work autonomously on branch `claude/nifty-babbage-49fdtw`; no PR unless asked. — Mission instructions. — n/a — reversible.
- D-002 — 2026-09-25 — Corridor: non-EU students (India beachhead) → Germany, first 90 days. — Highest repeatability, source quality, stability and value-without-legal-advice (CORRIDOR_COMPARISON score 57 vs ≤50). — PT, ES, CA, NL, UA→DE, skilled→DE. — Reversible (dataset architecture is corridor-agnostic).
- D-003 — Red-team verdict GO with narrowed thesis; pivots reserved: university white-label; residence-status tracker. — RED_TEAM.md.
- D-004 — Languages EN (primary) + DE (UI + official terms). Hindi/Telugu/Tamil deferred to validation. — English is the ICP's shared study language.
- D-005 — Local-first: no backend, no account, bundled dataset, JSON document store. — Privacy, offline, no credentials; data volume tiny.
- D-006 — Deterministic JSON rules engine; no LLM for applicability. — Mission rule; testability.
- D-007 — Do not store volatile amounts (blocked account, broadcasting fee) — link to source instead. — Reduces staleness risk.
- D-008 — Residence-permit deadline shown as the day before visa expiry, with suggested start 8 weeks earlier. — Conservative reading of §81(4) AufenthG ("before expiry").
- D-009 — "Overdue" only for legal deadlines; suggestions are labelled as such. — Avoid false alarms and false authority.
- D-010 — Hard dependencies require an evidence source; soft ordering is labelled app guidance and never blocks. — "Do not encode fake dependencies."
- D-011 — Name "Erstmal"; rejected "Ankommen" (official BAMF app) and "Settlewise" (taken). — Trademark search pending.
- D-012 — V1 monetization: free, no ads/affiliates; test B2B pilots and a fake-door one-time pack. — Trust; temporary problem.
- D-013 — Notifications generic by default on lock screen. — Immigration status is sensitive.
- D-014 — Android backups disabled. — Sensitive data should not silently migrate to cloud.
- D-015 — Sources verified via search index (direct fetch blocked); every rule flagged `review_required`. — Honesty over false precision.
