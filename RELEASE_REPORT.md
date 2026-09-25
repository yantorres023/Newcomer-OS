# Newcomer OS Autonomous Build Report

_Run date: 2026-09-25. Branch: `claude/nifty-babbage-49fdtw`._

## Executive Summary
I compared seven migration corridors. The one I picked is **non-EU international students arriving in Germany**, with students from India as the first community to target. It has the most repeatable, law-based post-arrival sequence, the best official sources, stable rules, and steps that can be explained without individual legal advice. The red team concluded **GO** with a narrowed thesis.

I built a working Flutter MVP called **Erstmal**. It is local-first, works offline and needs no account. It has a structured, versioned, validated rules dataset: 19 rules and 26 official sources, in English and German, with Berlin and Munich city packs. A deterministic rules engine produces a personal Today / Upcoming / Done checklist. Each task has a detail screen with its official source and the date it was last checked, plus reminders and notes. Analyzer is clean and **95/95 tests pass**. GitHub Actions CI is green: tests, the Android APK/AAB build, and the iOS build without signing all passed.

**Main caveat:** this environment could not open German government websites directly. Every rule was checked through search-engine extracts of the official pages, and every rule is flagged for human source and legal review. That review must happen before a public launch.

## Final Decision
**GO** (narrowed): first-90-days arrival checklist for international students in Germany. Two fallback pivots stay available: a university white-label version, or a residence-status tracker.

## Final Product Name
**Erstmal** (recommended; trademark search pending). Repo and internal name: Newcomer OS. Rejected: "Ankommen" (an official BAMF app) and "Settlewise" (already taken).

## Corridor Selected
Non-EU students on a national study visa (plus visa-free nationals such as the USA, Canada and Japan, and a reduced list for EU citizens) → Germany. City packs: Berlin and Munich. Other cities get the federal rules plus BAMF-NAvI to find their local office.

## User Profile
Aged 22–30, Master's or preparatory-course student, English-speaking, limited German, smartphone-first. Relies on creators, WhatsApp/Telegram batch groups and Reddit. Arrives in the Aug–Oct or Mar–Apr intakes.

## Why This Corridor Won
It scored 57 in the comparison matrix, against 45–50 for the alternatives. It led on repeatability, source quality, policy stability, low legal risk and "value without individual legal advice". Portugal and Spain have more pain but fast-changing, eligibility-heavy law. Canada and the Netherlands have shrinking student inflows and strong free services. See `docs/research/CORRIDOR_COMPARISON.md`.

## Problem
Newcomers must complete steps in a set order and by legal deadlines: address registration within 2 weeks; residence permit before the visa ends; insurance proof for enrolment; plus letters that arrive unannounced (tax ID, broadcasting fee). The information is spread across federal, city, university and community sources, often in German, and community advice is sometimes wrong. For example, "apply within 90 days" is common advice, but the actual rule is to apply before the visa expires.

## Public Evidence
- DAAD: about 402k international students in WS 2024/25; India is the largest group (about 59k, +20%).
- Statutes and city pages confirm the sequence and deadlines.
- University guides report foreigners'-office appointments "fully booked months ahead".
- Commercial bundles (Expatrio and similar) monetise through financial products.
- No human interviews were done. Reddit could not be fetched. See `docs/research/EVIDENCE_LEDGER.md`.

## Official Source Coverage
26 sources:
- federal law: BMG §17 and §19, AufenthG §16b and §81, AufenthV §41
- federal ministries, agencies and portals: BMI, Personalausweisportal, BAMF-NAvI, BZSt (×2), Auswärtiges Amt, Make it in Germany
- Berlin: 6 service pages
- Munich: 4 city pages
- public bodies: Rundfunkbeitrag, DAAD (×2), Deutsche Rentenversicherung

Corpus: `docs/research/OFFICIAL_SOURCES.md`.

## Evidence Strength
- **High:** the administrative sequence and deadlines exist.
- **Medium:** the pain points, from public complaints.
- **Low:** willingness to pay, trust, distribution. These are unvalidated with real users.

## Major Counter-Evidence
- Universities and DAAD already publish free checklists.
- Community groups answer questions for free.
- The problem is temporary (about 90 days).
- Appointment scarcity, the biggest pain, cannot be solved by an app.
- Many creators prefer affiliate products.

## Product Built
Flutter app for Android and iOS:
- welcome + disclaimer
- 7-question onboarding with "why we ask"
- summary of the selected tasks
- Today / Upcoming / Done tabs with progress and next deadline
- task detail: kind, our explanation vs the official source, when (legal / official guidance / our suggestion), dependencies, why, steps, documents (official vs commonly requested), source cards with authority, government-vs-public-body label and last-checked date, German terms, professional-help section, reminder, private notes, mark done, "I've checked the update", report outdated info
- sources page
- settings: edit answers, residence-card expiry, language, notification privacy, disclaimer, privacy, copy my data, delete all data

## Core User Flow
Install → disclaimer → answer 7 questions (about 1 minute) → checklist → open "Register your address" → see the legal deadline and the Berlin/Munich official page → open the source → set a reminder → mark done → the tax-ID follow-up date appears.

## Rule Architecture
Rules are JSON records with:
- id, version, status and kind
- an `applies_to` condition written in a small grammar over profile fields
- timing: anchor, offset, basis, suggested start
- dependencies: a hard dependency needs an evidence source; soft ordering is labelled as app guidance
- documents
- sources that can be switched by city or study stage
- effective dates, last verified, review flag, confidence, official terms, EN/DE content, professional help
- `supersedes` and `rule_history`

The validator enforces integrity at runtime and in CI, including source coverage for all 144 profile combinations. See `docs/engineering/RULES_AUTHORING.md`.

## Number of Rules / Tasks Covered
- 19 active rules, plus 1 superseded history entry.
- Per user: 7 tasks (EU citizens) up to 18 tasks (non-EU with every optional answer), depending on profile. 2 of them are event tasks (moving within Germany, leaving Germany).

## Source Freshness Strategy
- Every task shows its source, authority and last-checked date.
- The validator warns about sources older than 180 days.
- Sources are reviewed each semester using the documented process.
- A future monitoring job would work as: detect change → open review issue → human edits → new dataset version. Production rules are never changed automatically.
- Users are prompted to re-check tasks whose rule version changed after they completed them.

## Localization
- UI: English and German (gen-l10n, 175 strings).
- Content: EN/DE for every rule and document. Official German terms are shown next to the explanations, and source titles stay in their original language.
- If a translation is missing, the app falls back to English and says so.
- The German text needs native-speaker review.

## Architecture
- Pure-Dart domain layer: LocalDate, Condition, Dataset, Validator, Resolver.
- Data layer: asset loader and versioned JSON store with atomic writes, migrations and quarantine of corrupt files.
- Services: local notifications, allowlisted link opener, analytics interface.
- State: ChangeNotifier + InheritedNotifier.
- No backend. See `docs/engineering/TECHNICAL_PLAN.md`.

## Privacy
- Local-only; no account, server, SDKs or analytics upload.
- Only categorical answers and 4 dates are collected.
- Notifications are generic by default.
- Android backups are disabled.
- Data can be exported and deleted in the app.
- Data map: `docs/engineering/SECURITY.md`. Draft policy: `legal/PRIVACY_POLICY.md`.

## Security
Only dataset https links can be opened (tested against http, javascript: and intent:). No deep links. Minimal permissions: notifications and boot. An invalid dataset is refused. Details in `docs/engineering/SECURITY.md`.

## Legal / Informational Limitations
- Information and organisation only; not legal advice.
- Not affiliated with any authority; the official source prevails.
- Professional-help sections appear where situations are individual: over-30 insurance, family, expired visa, refusals, freelancing.
- Positioning under the Rechtsdienstleistungsgesetz still needs confirmation by German counsel.

## Tests
`flutter analyze`: no issues. `dart format`: clean. **`flutter test`: 95 passed, 0 failed.** Coverage:
- dates: DST, month clamping
- conditions
- resolver: all profile combinations, deadlines, missing dates, overdue logic, dependencies, supersession, effective windows, profile no longer qualifying, task completed before a rule update, rule removed, fallback language
- storage: round-trip, v1→v2 migration, corrupt data, newer schema, atomic file writes, deletion
- link allowlist; notification ids
- controller: persistence, reminders, permission denied, cancelling reminders when the profile changes, analytics carrying no profile data, export/delete, invalid dataset, missing asset
- widgets: full first run, task detail + source opening, German UI, empty state, delete flow, 200% text scale, tap-target/label/contrast guidelines

## Dataset Validation
`test/dataset/dataset_integrity_test.dart` checks:
- the real dataset passes validation
- manifest and version match
- ids are unique and every source is used
- every language has content
- no forbidden marketing claims

15 mutation tests prove the validator rejects: duplicate ids, missing or unknown sources, broken or cyclic dependencies, hard dependencies without evidence, missing translations, inverted effective dates, verification dates in the future, unknown fields, http URLs, legal deadlines without a statute, city-source gaps, bad anchors, and overlapping history.

## Android
- Configured: desugaring, notification receivers, permissions, backups off, https query, label "Erstmal".
- **`flutter build apk` could not run here.** The container has no Android SDK, and `dl.google.com` is blocked by the environment's network policy.
- **CI run #1 (https://github.com/yantorres023/Newcomer-OS/actions/runs/36142127506): the `android` job passed.** It built the release APK and the AAB and uploaded them as the `android-builds` artifact.
- The application ID `app.erstmal.newcomer_os` is a placeholder. Release builds are debug-signed until an upload key exists.

## iOS
- Configured: notification delegate, display name, localizations, encryption flag.
- **CI run #1 (https://github.com/yantorres023/Newcomer-OS/actions/runs/36142127506): the `ios` job passed** on macos-latest: 95 tests plus `flutter build ios --release --no-codesign`.
- Signing and TestFlight need an Apple Developer account (see `release/ios/README.md`).

## Monetization
Free V1 with no ads or affiliates. Primary hypothesis: university and student-union pilots (B2B2C). Secondary: fake-door test of a one-time "Arrival Pack". Subscriptions and affiliates were rejected for V1, with reasons in `docs/business/MONETIZATION.md`.

## Distribution
- Creator outreach (no affiliate needed) and partnerships with international offices and AStA.
- Share-with-your-batch.
- 10 short-form content concepts and 10 SEO pages in `docs/business/DISTRIBUTION.md`.
- Nobody was contacted.

## Landing Page
`landing/index.html`: static, responsive, dark mode. It says who the app is for, what it solves and how it works, explains the official-sources approach, lists the sources, states the privacy model, and says clearly that the app is not a government service. No testimonials, no government imagery.

## Known Bugs
None known from tests. Not yet verified:
- behaviour on real devices, especially notification delivery under battery optimisation
- the timezone edge when the device clock is still in the origin country

## Known Knowledge Gaps
- Munich: no official source yet for collecting the residence card or for family members (the app falls back to federal and BAMF sources).
- The exact student health-insurance age rule is worded vaguely on purpose.
- The date of the 2024 work-limit change is unverified.
- The legal registration duty for the broadcasting fee is not stated (the date shown is labelled as our suggestion).
- Only Berlin and Munich have city packs.
- No content for Studienkolleg-specific or PhD-employment situations.

## External Blockers
- The network policy blocked German government sites and `dl.google.com`, so there was no direct source verification and no local Android build.
- No Apple or Google developer accounts; no signing keys.
- No publisher legal identity (needed for Impressum, privacy policy and store accounts).

## HUMAN_ACTION_REQUIRED

**1. Source and legal review of the dataset (blocks public launch)**
- **Why:** rules were checked only through search extracts; wrong migration guidance can cause harm.
- **Exact steps:**
  1. Open each URL in `docs/research/OFFICIAL_SOURCES.md`.
  2. Confirm each "claim relied upon" and the matching rule text.
  3. Have a German migration-law practitioner review the `de.residence.*`, `de.work.limits`, `de.insurance.over_30` and `de.family.dependants` rules, the disclaimer, and the Rechtsdienstleistungsgesetz positioning.
  4. Set `verification_method`, `last_verified_at`, and `review_required: false` per rule.
  5. Bump the dataset version.
- **Expected result:** validator warnings for "pending review" disappear, and the dataset is safe for beta or launch.

**2. ~~Run CI on GitHub~~ — done, run 36142127506 is green; download the `android-builds` artifact to side-load the APK**
- **Why:** the Android and iOS builds could not run here.
- **Exact steps:**
  1. Make sure GitHub Actions is enabled for the repo.
  2. Push this branch (already pushed), or open a PR to main.
  3. Check the `quality`, `android` and `ios` jobs.
  4. Download the `android-builds` artifact.
- **Expected result:** three green jobs, an APK and an AAB.

**3. Publisher identity and legal documents**
- **Why:** needed for the privacy policy, terms, Impressum and store accounts.
- **Exact steps:**
  1. Decide who publishes the app (organisation recommended).
  2. Fill in the placeholders in `legal/*.md`.
  3. Get legal review.
  4. Host the policy and terms, plus a support page (the landing page can serve as the base).
- **Expected result:** privacy policy and support URLs for the store listings.

**4. Trademark and name check for "Erstmal"**
- **Exact steps:** search DPMA, EUIPO and USPTO in classes 9 and 42; decide the final name, then the application ID and bundle ID.
- **Expected result:** a final name and IDs, which cannot be changed after the first upload.

**5. Google Play release**
- **Exact steps:** follow `release/android/README.md`: account, upload key, signing config, internal testing, data safety form, and the government-information declaration.
- **Expected result:** an internal testing build.

**6. Apple release**
- **Exact steps:** follow `release/ios/README.md`: developer program, bundle ID, signing, TestFlight.
- **Expected result:** a TestFlight build.

**7. Native German content review**
- **Exact steps:** review the `lib/l10n/app_de.arb` strings and all `content.de` blocks in the rules.
- **Expected result:** natural and accurate German.

## SOURCE_REVIEW_REQUIRED
All 19 rules and all 26 sources. The per-rule questions are in `docs/research/SOURCE_REVIEW_DEBT.md`. Highest priority:
- `de.residence.permit_application`
- `de.residence.permit_application_visa_free`
- `de.residence.fiktionsbescheinigung`
- `de.work.limits` (plus its history date)
- `de.insurance.health_insurance` and `de.insurance.over_30`

## Real-User Validation Debt
17 hypotheses with tests, metrics and pass/fail thresholds in `docs/research/VALIDATION_DEBT.md`. The main ones: trust and comprehension, activation, source opening, onboarding drop-off, willingness to pay, B2B pilots, creator distribution, and language needs.

## Suggested Beta Cohort
- 30–50 non-EU students arriving for the next intake (summer semester 2027, or late WS 2026/27 arrivals) in Berlin and Munich, with about 70% from India.
- Plus about 10 students from other cities, to measure the gap without a city pack.
- Recruit through 2–3 international offices and 2 student batch groups.
- Framing: "pre-release: verify everything with the official source".

## Experimental Success Gates
- Onboarding completion ≥ 80%
- Activation (roadmap + 1 task done + 1 source opened within 7 days) ≥ 40%
- ≥ 50% of activated users open an official source
- ≥ 40% complete 5+ tasks within 30 days
- ≥ 50% return on 3+ days within 30 days
- Fewer than 1 confirmed info error per 50 users, and zero critical errors

## Kill / Pivot Gates
- **STOP launch** on any unfixable critical rule error.
- **PIVOT to university white-label** if activation is ≥ 40%, willingness to pay is < 2%, and at least 2 universities want a pilot.
- **PIVOT to residence-status tracker** if renewal and work-day tracking beats first-90-days value.
- **STOP** if activation stays below 20% after two iterations and there are no pilots.

## Next 3 Experiments
1. **5 moderated usability and comprehension sessions** with arriving students. Measures: onboarding friction, and whether users understand "our explanation vs the official source". Cost: about one week.
2. **Outreach to 10 international offices in Berlin and Munich** offering a free pilot. Target: at least 2 pilots.
3. **Closed beta of 30–50 users with a fake-door "Arrival Pack"** measuring activation, source opens and pack tap-through.

## Files To Review First
1. `docs/research/SOURCE_REVIEW_DEBT.md` and `assets/roadmaps/de-students/rules.json`
2. `docs/research/CORRIDOR_COMPARISON.md`, `RED_TEAM.md`, `FINAL_RED_TEAM.md`
3. `lib/domain/roadmap_resolver.dart`, `lib/domain/dataset_validator.dart`
4. `lib/ui/task/task_detail_screen.dart`
5. `legal/PRIVACY_POLICY.md`, `legal/TERMS.md`, `docs/product/DISCLAIMER.md`
6. `.github/workflows/ci.yml`

## Final Repository Status
- Branch `claude/nifty-babbage-49fdtw`, pushed.
- Analyzer clean, 95/95 tests passing.
- **CI green:** quality, android and ios jobs all passed on commit `ac7ec92` (run 36142127506).
- No PR opened (none requested).
