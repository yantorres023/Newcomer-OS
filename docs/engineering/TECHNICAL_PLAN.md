# Technical Plan

## Stack
Flutter 3.47.5 (stable), Dart 3.13. Android + iOS. No backend.

## Architecture (as built)
```
lib/
  domain/        pure Dart, no Flutter imports (except none) — fully unit-testable
    local_date.dart        calendar dates, timezone-free deadline arithmetic
    profile.dart           UserProfile (only rule-selection answers)
    condition.dart         deterministic condition grammar
    dataset.dart           RoadmapDataset / RuleDefinition / Source / Timing / Dependency
    dataset_validator.dart integrity checks (used at runtime and in CI)
    roadmap_resolver.dart  profile + rules + user state → Roadmap(TaskInstance…)
    user_state.dart        completions, notes, reminders, settings (separate from rules)
  data/
    dataset_loader.dart    loads bundled assets via manifest, validates, rejects invalid
    local_store.dart       versioned JSON document store, atomic writes, migrations, quarantine
  services/
    reminder_service.dart  ReminderScheduler interface; flutter_local_notifications impl; fake
    link_service.dart      https + dataset-allowlist URL opener
    analytics.dart         event interface; debug-only sink
  state/
    app_controller.dart    ChangeNotifier; single source of truth
    app_scope.dart         InheritedNotifier
  ui/                      screens & widgets
  l10n/                    ARB (en, de) + generated localizations
assets/roadmaps/
  manifest.json            active dataset + version
  de-students/rules.json   rules (versioned release 2026.09.1)
  de-students/sources.json sources
  de-students/CHANGELOG.md
```

## Decisions
| Area | Choice | Why |
|------|--------|-----|
| Navigation | Navigator 1.0 + tabs | 5 screens; no deep links needed in V1 (smaller attack surface) |
| State | ChangeNotifier + InheritedNotifier | No dependency; state is small; easy to test |
| Local DB | Single JSON document, schema-versioned, atomic rename | < 100 records; human-inspectable export; migrations tested. Revisit (drift/sqlite) if a document vault or history is added |
| Rules engine | JSON conditions evaluated in Dart | Deterministic, inspectable, testable; no LLM |
| Localization | gen-l10n ARB for UI; per-rule `content.{lang}` for dataset | UI and content versioned separately |
| Notifications | flutter_local_notifications, inexact scheduling at 09:00 local | No exact-alarm permission; day-level precision is enough |
| Timezones | Deadlines are `LocalDate` (no time); notification time via `timezone` + device zone | Avoids DST/UTC off-by-one; device may still be in origin timezone before travel |
| Links | url_launcher external browser, allowlist | No in-app webview; users see real domain |
| Remote updates | None in V1 | Dataset ships with app; update = app release. See source-monitoring design |
| Analytics | Interface only | Privacy-first; no SDK |
| AI | None | V1 must work without AI (see AI policy below) |

## Rule engine semantics
- Rule is shown iff `status == active` ∧ effective on today ∧ `applies_to(profile)`; or it was completed (kept in Done, marked "no longer applies").
- Due date: `after_anchor` (profile date or `completed:<rule>` + months/days) or `before_anchor` (profile date − days). Missing profile anchor → `missingAnchor` (UI asks for the date; nothing invented).
- Urgency: overdue only for `basis: legal`; suggestions/guidance past date → "due soon".
- Buckets: Done > When it happens (event) > Upcoming (blocked by hard dep) > Today (urgent / suggested start reached / asap / missing anchor) > Upcoming.
- Hard dependencies (`requires`) need an `evidence_source_id`; soft (`recommended_after`) are app guidance and never block. Dependencies on non-applicable rules are ignored.
- Completion stores rule version; if the rule's version increases, "updated since you completed" is shown. `supersedes` carries completion to a replacement rule id.

## Testing
`flutter test` (95 tests): LocalDate, conditions, resolver (all 144 categorical profile combinations, deadlines, dependencies, supersession, effective windows, profile changes, fallback language), dataset integrity + 15 mutation tests, local store (round-trip, v1→v2 migration, corruption, newer schema, file atomicity), link allowlist, notification ids, controller (persistence, reminders, analytics privacy, delete/export, invalid dataset), widget flows (first run, task detail, German UI, empty state, delete, 200% text scale, accessibility guidelines).

## CI (`.github/workflows/ci.yml`)
quality (format, analyze, dataset tests, all tests + coverage) → android (APK + AAB) and ios (macOS tests + `flutter build ios --release --no-codesign`).

## Android
minSdk from Flutter default (24), compileSdk 36 via Flutter; core library desugaring for notifications; POST_NOTIFICATIONS + RECEIVE_BOOT_COMPLETED; backups disabled (`allowBackup=false`, data-extraction rules exclude everything); https VIEW query for url_launcher. Release signing pending owner's key.

## iOS
Deployment target 15.0; notification delegate set in AppDelegate; display name "Erstmal"; `ITSAppUsesNonExemptEncryption=false`. Signing/TestFlight pending Apple account.

## AI policy (future)
Allowed later, isolated behind an interface, always with deterministic fallback: plain-language rewrite of already-sourced content, translation drafts for human review, summarising a source page for reviewers. Never: deciding applicability, inventing requirements, answering individual legal questions.

## Known technical limitations
- Android/iOS builds could not run in the build container (no Android SDK; Linux) but pass in GitHub Actions (run 36142127506).
- Notification behaviour not device-tested.
- No app-level iOS privacy manifest file added (plugins ship their own); verify at first App Store upload.
