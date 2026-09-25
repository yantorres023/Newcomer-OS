# Analytics — EXPERIMENTAL

V1 ships **without** remote analytics. `lib/services/analytics.dart` defines the events and a sink interface; the only sink in the app prints to the debug console in debug builds. Adding a remote sink requires: privacy-policy update, store privacy-label update, opt-in consent screen, legal review.

## Events
| Event | Properties (never profile answers or dates) |
|-------|------|
| onboarding_started | – |
| onboarding_completed | – |
| roadmap_generated | task_count |
| profile_updated | – |
| task_viewed | rule_id |
| official_source_opened | rule_id, source_id |
| reminder_created | rule_id |
| task_completed | rule_id, completed, total |
| task_reopened | rule_id |
| language_changed | language |
| data_deleted | – |

A unit test asserts that analytics payloads never contain dates, city or entry type.

Note: even rule ids can be sensitive in aggregate (e.g. `de.family.dependants` implies family situation). A future remote sink must aggregate or drop such ids.

## Candidate metrics (beta)
- **Onboarding completion** = onboarding_completed / onboarding_started.
- **Activation** = roadmap_generated + ≥ 1 task_completed + ≥ 1 official_source_opened within 7 days.
- **Value** = share of activated users opening ≥ 1 official source.
- **Progress** = share completing ≥ 5 tasks within 30 days.
- **Retention** = return on ≥ 3 distinct days within first 30 days.
- **Trust** = reports of incorrect/outdated info per 100 active users (via report feature; manual channel in beta).

## Beta measurement without SDKs
For a closed beta (≤ 100 users), use: TestFlight / Play internal-testing install counts, a voluntary in-app "copy my progress summary" (future), and structured interviews. Do not add tracking SDKs to reach these numbers.
