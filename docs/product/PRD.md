# PRD — Erstmal V1 (Germany, international students)

## VISION
Every newcomer knows the next administrative step, why it matters, when it is due and where the official rule lives — privately, offline, without an account.

## ICP
See `PRODUCT_STRATEGY.md`. Non-EU students on a national study visa (plus visa-free nationals and EU citizens with a reduced roadmap), Berlin/Munich/other cities.

## JTBD
Get registered, insured, enrolled and residence-permitted on time; avoid surprise obligations (broadcasting fee, tax ID letter); know the work rules.

## NON-GOALS
- Legal advice, eligibility decisions, approval predictions.
- Filing applications, automating government accounts, booking appointments.
- Document vault / storing passport, visa, tax or ID images or numbers.
- Tax filing, bank or insurance sales, paid referrals.
- Free-form AI chatbot for legal questions.
- Pre-departure visa application support (V1 is post-arrival).

## ROADMAP SCOPE (dataset `de-students` 2026.09.1)
19 active rules: landlord confirmation, address registration, find foreigners' authority (other cities), health insurance, insurance ≥ 30, bank account & blocked-account payout (practical), enrolment, broadcasting fee, residence permit (national visa), residence permit (visa-free, 3 months), fictional certificate, tax ID letter, collect residence card, work limits, social insurance number, family members, permit renewal, re-register on move (event), deregister on leaving (event). 26 sources.

## USER STORIES & ACCEPTANCE CRITERIA
1. **As a newcomer I answer a few questions and get my checklist.**
   - ≤ 8 questions; each shows "why we ask"; Next disabled until answered; dates can be "not yet / add later".
   - Summary shows number and titles of selected tasks. ✅ implemented, widget-tested.
2. **I see what to do now.**
   - Today = overdue legal deadlines, due ≤ 14 days, suggested start reached, "as soon as possible" tasks not blocked by a hard dependency. Upcoming = blocked or later. Done = completed. Event tasks in "When it happens". ✅ unit-tested.
3. **I understand a task.** Detail shows title, kind (official requirement / process / practical / good to know), summary labelled as our explanation, when (with basis: legal / official guidance / our suggestion), dependencies, why, steps, documents (official vs commonly requested), official source(s) with authority, government vs public-body label, last-checked date, official German terms, notes, professional-help section, who it applies to. ✅
4. **I open the official source.** Opens in external browser; only dataset https URLs; failure shows copy-link fallback. ✅ tested.
5. **I mark tasks done / undo.** Persisted locally; records rule version; flagged if the rule is updated later. ✅
6. **I set a reminder.** Options: 1 week before, 1 day before, tomorrow, custom; permission denial handled; generic lock-screen text by default. ✅ (scheduler faked in tests; device behaviour untested here).
7. **I edit my answers.** Tasks added/removed deterministically; reminders of removed tasks cancelled; completed-but-no-longer-applicable tasks remain in Done with a label. ✅
8. **I switch language (EN/DE).** UI and content switch; missing translation falls back to English with a notice. ✅
9. **I delete or copy my data.** ✅

## RULE ARCHITECTURE
See `docs/engineering/RULES_AUTHORING.md`. Structured JSON rules with id, version, status, kind, jurisdiction, `applies_to` condition, timing (anchor, offset, basis), dependencies (hard with evidence / soft), documents, conditional sources, effective dates, last verified, review flag, confidence, official terms, localised content, professional help. Rule history keeps superseded versions.

## SOURCE POLICY
- Official requirements must cite a government or public-body source; legal deadlines must cite a statute or city authority page.
- Community sources may inform pain research, never rules.
- Volatile amounts (fees, blocked-account amount) are not stored; users are sent to the source.
- Each source records verification method; V1 sources were checked via search index (direct fetch blocked in build environment) → all flagged for human re-check before launch.

## LOCALIZATION
English (primary) and German. Official German terms shown alongside explanations. Source titles kept in original language with `title_language`.

## PRIVACY
Local-only JSON document; no account, backend, analytics upload or third-party SDKs; Android backups excluded; export and delete in-app. See `docs/engineering/SECURITY.md`, `legal/PRIVACY_POLICY.md`.

## ANALYTICS
Event interface with debug-only sink; nothing transmitted in V1. See `ANALYTICS.md`.

## ACCESSIBILITY
Semantic headers, labelled controls, icon+text status (no colour-only meaning), 48dp targets, text scaling to 200% tested, contrast guideline tested.

## ERROR HANDLING
Invalid dataset → explicit error screen (no partial content). Corrupt local data → quarantined copy + fresh start + notice. Save failure → banner. Link failure → copy-link fallback. Missing dates → prompt to add, never invented.

## LEGAL LIMITATIONS
Information/organisation only; not legal advice; not affiliated with any authority; users must verify with official sources; professional-help prompts where situations are individual.

## RELEASE REQUIREMENTS
- Human source review of all 19 rules (SOURCE_REVIEW_DEBT) ✗
- Legal review of disclaimer, privacy policy, terms ✗
- Native-speaker review of German content ✗
- Trademark check of name ✗
- Store accounts, signing, support URL/email ✗
- CI green on Android + iOS builds ✗ (pending first run)

## VALIDATION DEBT
See `docs/research/VALIDATION_DEBT.md`.
