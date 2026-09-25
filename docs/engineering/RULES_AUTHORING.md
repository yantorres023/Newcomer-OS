# Rules & Sources Authoring Guide

Rules live in `assets/roadmaps/<dataset>/rules.json`, sources in `sources.json`, and `assets/roadmaps/manifest.json` selects the active dataset and version. Every change goes through a pull request and CI (`flutter test test/dataset`).

## Field reference (rule)
| Field | Meaning |
|-------|---------|
| `id` | `de.<category>.<name>`, never reused for a different meaning |
| `version` | Integer; bump on any change of meaning (deadline, applicability, steps, documents) |
| `status` | `active` · `draft` (never shown) · `superseded` · `retired` |
| `kind` | `official_requirement` · `official_process` · `practical` · `information` |
| `applies_to` | Condition over profile fields (see `lib/domain/condition.dart`) |
| `timing` | `after_anchor` / `before_anchor` (anchor = profile date or `completed:<rule_id>`, `offset_days`, `offset_months`), `asap`, `event`, `none`; `basis` = `legal` · `official_guidance` · `app_suggestion`; optional `suggested_start_days_before` |
| `depends_on` | `requires` (needs `evidence_source_id`) or `recommended_after` (app guidance) |
| `required_documents` | `{doc, basis: official|commonly_requested}`; doc ids defined in `documents` |
| `sources` | `{source_id, when?}`; `when` selects city/situation-specific pages; at least one source must match every profile (validator checks all combinations) |
| `effective_from` / `effective_until` | Legal effect window; `null` = unknown/open |
| `last_verified_at` | Date a human (or, in V1, a search-index check) confirmed the content |
| `review_required` | `true` until a human reviewer signs off |
| `confidence` | `high` · `medium` · `low` |
| `official_terms` | German terms users will encounter |
| `content.{en,de}` | title, summary, why, steps[], notes |
| `professional_help.{en,de}` | When to seek individual advice (optional) |
| `supersedes` | Old rule id replaced by this one (completion carries over, flagged) |

Source fields: `id`, `title` (original language), `title_language`, `authority`, `authority_type`, `url` (https), `last_verified_at`, `verification_method` (`direct_fetch` · `search_index` · `manual`), `verified_claims[]` (the exact statements relied upon).

## How to add a rule
1. Find the primary source (statute, ministry, agency, city portal). Community content is not a source.
2. Add/extend the source in `sources.json` with `verified_claims` quoting what you rely on.
3. Add the rule with `version: 1`, `status: draft`, `review_required: true`.
4. Write EN + DE content. Don't store volatile amounts; link instead. Use "our suggestion" basis for any date not stated by the source.
5. Add resolver tests for applicability and deadline.
6. Reviewer checks source vs content, sets `status: active`, `review_required: false`, `last_verified_at`.
7. Bump dataset `version` (`YYYY.MM.N`) in `rules.json` and `manifest.json`; add a CHANGELOG entry.

## How to modify a rule
- Wording-only fix: edit content, keep version, update `last_verified_at`.
- Meaning change: bump `version`, move the previous version's summary into `rule_history` (`status: superseded`, `superseded_by_version`, `effective_until`). Users who completed the old version see "updated since you completed".

## How to supersede a rule with a new id
Create the new rule with `supersedes: "<old id>"`, remove the old rule from `rules`, record it in `rule_history`. The validator rejects keeping both active.

## How to retire a rule
Set `status: retired` (hidden) for one release, then remove it and record in `rule_history`.

## How to review sources (per release, at least each semester before Apr and Oct intakes)
1. Open every source URL (script: list all URLs from `sources.json`).
2. Check each `verified_claims` item is still stated; check for moved pages (404/redirect).
3. Update `last_verified_at`, `verification_method: direct_fetch` (or `manual`).
4. Anything changed → modify/supersede rules as above.
5. Validator warns for sources older than 180 days.

## Source-monitoring architecture (future, not built)
```
Scheduled job (e.g. GitHub Actions cron, no user data)
  → fetch each source URL, normalise text, hash + store snapshot (repo or bucket)
  → diff vs last snapshot; also detect HTTP errors/redirects
  → CHANGE DETECTED: open an issue/PR "source src.x changed" with diff
  → REVIEW: human reviewer compares with verified_claims; edits rules
  → UPDATED VERSION: new dataset version → app release (V1) or signed remote dataset (V2)
```
Rules: detection never edits production rules automatically; remote dataset delivery (V2) must be signed, validated on device with the same validator, and fall back to the bundled dataset on any failure.
