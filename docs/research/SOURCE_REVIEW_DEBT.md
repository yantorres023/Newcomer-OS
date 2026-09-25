# Source Review Debt

**Critical before commercial launch.** No rule in dataset `de-students 2026.09.1` has been reviewed by a human with direct access to the official page. All rules carry `review_required: true`.

## Why
The build environment could not fetch German government sites (egress policy). Claims were confirmed from search-index extracts of the official pages. This is weaker than reading the page: extracts can be stale, truncated or paraphrased.

## Global actions
1. **Manual verification** — open every source URL, confirm each `verified_claims` line, set `verification_method: direct_fetch`/`manual`.
2. **Legal review** — German migration-law practitioner reviews the residence-permit, Fiktionsbescheinigung, visa-free and work-limit rules and all 'professional help' thresholds; confirm positioning under the Rechtsdienstleistungsgesetz.
3. **Local expert review** — Berlin and Munich international offices (or experienced student advisors) review city steps.
4. **Native German review** of all `de` content and UI strings.
5. **Freshness re-check** — before each intake (Mar/Sep).

## Per-rule review list

| Rule | Kind | Timing basis | Confidence | Manual verify | Legal review | Local expert | Specific open questions |
|---|---|---|---|---|---|---|---|
| `de.housing.landlord_confirmation` v1 | official_requirement | legal | high | Yes | Recommended | Yes | Confirm dorm/sublet cases (main tenant as Wohnungsgeber). |
| `de.registration.anmeldung` v1 | official_requirement | legal | high | Yes | Recommended | Yes | Confirm Munich online registration availability for non-EU first registration; appointment-shortage guidance wording. |
| `de.residence.find_authority` v1 | information | asap | high | Yes | Yes | No | Confirm BAMF-NAvI still lists Ausländerbehörden by postcode. |
| `de.insurance.health_insurance` v1 | official_requirement | asap | high | Yes | Recommended | No | Legal nuance of exemption (Befreiung) irreversibility; electronic notification (Meldeverfahren) wording. |
| `de.insurance.over_30` v1 | information | asap | medium | Yes | Yes | No | Exact age rule (end of semester in which 30 is reached? exceptions?) — deliberately vague; needs expert wording. |
| `de.money.bank_account` v1 | practical | asap | medium | Yes | Recommended | No | Practical, not legal; confirm AA page URL (two URL variants seen). |
| `de.university.enrolment` v1 | official_process | asap | high | Yes | Recommended | No | Accident-insurance statement at enrolment (from DAAD) — confirm. |
| `de.broadcast.rundfunkbeitrag` v1 | official_requirement | app_suggestion | high | Yes | Recommended | No | Legal registration timing (Anzeigepflicht) not stated in app — decide whether to add with statute source. |
| `de.residence.permit_application` v1 | official_requirement | legal | high | Yes | Yes | Yes | Day-before-expiry conservative deadline; §81(4) wording; 8-week suggestion; document lists per city. |
| `de.residence.permit_application_visa_free` v1 | official_requirement | legal | high | Yes | Yes | Yes | Nationality list and 3-month counting; Schengen prior-stay caveat. |
| `de.residence.fiktionsbescheinigung` v1 | information | none | high | Yes | Yes | Yes | Travel restrictions with Fiktionsbescheinigung — confirm wording; automatic vs on-request per city. |
| `de.tax.tax_id_letter` v1 | official_process | official_guidance | high | Yes | Recommended | No | 3–4 weeks delivery (BZSt FAQ) and 3-month follow-up — confirm. |
| `de.residence.collect_card` v1 | official_process | none | medium | Yes | Yes | Yes | Berlin 4–5 weeks, proxy ≥14 — confirm; Munich process unknown (no Munich source). |
| `de.work.limits` v2 | official_requirement | none | high | Yes | Yes | No | 140/280 and effective date 2024-03-01 of change from 120/240 — verify date in BGBl. |
| `de.work.social_insurance_number` v1 | official_process | none | high | Yes | Recommended | No | Automatic issuance for foreign students — confirm. |
| `de.family.dependants` v1 | information | asap | medium | Yes | Yes | Yes | Only a signpost; confirm Berlin page URL; no Munich source. |
| `de.residence.permit_renewal` v1 | official_requirement | legal | high | Yes | Yes | Yes | Berlin 2 years / Munich up to 3 years validity statements; 12-week suggestion. |
| `de.registration.re_register_on_move` v1 | official_requirement | event | high | Yes | Recommended | No | Confirm foreigners-authority change on move wording. |
| `de.registration.deregister_on_leaving` v1 | official_requirement | event | high | Yes | Recommended | Yes | Confirm Berlin/Munich deregistration pages and online/postal options. |

## Rule history
- `de.work.limits` v1 (120/240 days, effective until 2024-02-29) — date needs verification against the Federal Law Gazette.

## Sources
All 26 sources in `OFFICIAL_SOURCES.md` need direct verification. Two sources (`src.bmi.meldewesen`, `src.personalausweisportal.eat`) only establish that the page exists — confirm content relevance.
