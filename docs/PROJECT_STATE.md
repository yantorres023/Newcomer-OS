# PROJECT STATE — Newcomer OS / Erstmal

_Last updated: 2026-09-25 (end of autonomous run)_

## CURRENT PHASE
MVP complete, pre-beta. Waiting on human source/legal review, store accounts, and first CI run.

## CURRENT CORRIDOR
Non-EU international students (beachhead: students from India) → Germany, first ~90 days after arrival on a national study visa. City packs: Berlin, Munich; other cities via federal rules + BAMF-NAvI.

## CURRENT ICP
22–30-year-old non-EU degree/prep student, English-speaking, limited German, smartphone-first, arriving for winter/summer semester.

## CURRENT PRODUCT THESIS
"Know what to do next after arriving in Germany — in the right order, by the right date, with the official source for every step." Private, offline, no account. Free for students; B2B (universities) is the primary monetization hypothesis.

## SUPPORTED ASSUMPTIONS
- Repeatable, statute-backed post-arrival sequence exists (BMG §17/§19, AufenthG §16b/§81, AufenthV §41, BZSt, Rundfunkbeitrag).
- Large and growing ICP (~402k international students, India largest group — DAAD).
- Rules stable enough for periodic manual maintenance (volatile amounts excluded).

## UNVALIDATED ASSUMPTIONS
All user-behaviour and willingness-to-pay assumptions (see docs/research/VALIDATION_DEBT.md), incl. trust, activation, B2B interest, creator distribution, language needs.

## REJECTED ASSUMPTIONS
- Worldwide generic newcomer app.
- Brazil→Portugal (policy churn), LatAm→Spain (eligibility/legal risk; regularisation window closed 30 Jun 2026), India→Canada (shrinking inflow, strong free settlement services), NL students (shrinking, strong free centres) as beachheads.
- Subscription as default monetization; affiliate referrals in V1.

## COMPLETED WORK
Research (comparison, selection, evidence ledger, red team GO, final red team) · dataset 2026.09.1 · rules engine + validator · Flutter app (onboarding, Today/Upcoming/Done, task detail, sources, reminders, notes, settings, EN/DE, export/delete) · 95 tests · CI (format/analyze/test, Android APK+AAB, iOS no-codesign) · product/engineering/business/legal/release docs · landing page · RELEASE_REPORT.md.

## RULE COVERAGE
19 active rules (+1 superseded history entry), 144/144 categorical profile combinations resolve with ≥1 source per task.

## SOURCE COVERAGE
26 sources: federal law (6), federal ministries/agencies/portal (6), Berlin (6), Munich (4), public bodies (4). All verified via search index only → review debt.

## KNOWN RISKS
Unreviewed rule content (blocking for public launch); distribution; monetization; reminder reliability untested on devices.

## BLOCKERS
- Build environment: no Android SDK and dl.google.com blocked → Android build not run locally; German gov sites not directly fetchable.
- Human: store accounts, signing, legal review, source review, trademark search, publisher identity.

## NEXT ACTION
Run CI on GitHub; human source + legal review of residence-permit rules; recruit 30–50 beta users for the next intake.
