# Corridor Comparison

_Research date: 2026-09-25. Method: public web search (search-engine index; direct fetch of most government sites was blocked by this build environment's network policy — see `SOURCE_REVIEW_DEBT.md`). No human interviews were conducted._

Evidence labels used: **FACT** (published statistic/official statement), **OFFICIAL** (official requirement), **COMMUNITY** (community/creator/commercial content), **INFERENCE** (our reasoning), **HYPOTHESIS**.

## Candidates

| ID | Corridor | Situation |
|----|----------|-----------|
| A | Non-EU students (India as beachhead community) → Germany | Arrived on a national study visa; first ~90 days: registration, insurance, residence permit |
| B | Brazilians → Portugal | Workers / job seekers regularising with AIMA |
| C | Latin Americans → Spain | Residents regularising (2026 extraordinary regularisation) / new residents |
| D | Indians → Canada | Students / workers / PRs landing |
| E | Non-EU students → Netherlands | Arrival, BRP registration, BSN, residence permit via institution |
| F | Ukrainians → Germany | Temporary protection holders |
| G | Non-EU skilled workers → Germany | EU Blue Card / skilled worker arrival |

## Key evidence per candidate

**A. Students → Germany**
- FACT: ~402,000 international students in WS 2024/25, +6% YoY; India the largest origin (~59,000, +20%) — [DAAD press release](https://www.daad.de/en/press-releases/erneut-hohe-zahl-an-internationalen-studierenden-in-deutschland/). Secondary report of 69,816 Indian students in WS 2025/26 ([gostudyin.com](https://gostudyin.com/india/news/record-indian-student-enrolment-2025-26/)) — not verified against DAAD primary data.
- OFFICIAL: Address registration within two weeks of moving in (BMG §17); landlord confirmation (BMG §19); residence permit for studies (AufenthG §16b) with 140 full / 280 half working days; application before visa expiry keeps status via Fiktionswirkung (AufenthG §81(4), not for Schengen visas); tax ID mailed automatically after first registration (BZSt); broadcasting fee per dwelling (rundfunkbeitrag.de); proof of health insurance for enrolment (DAAD / study-in-germany.com).
- COMMUNITY: Large creator/blog ecosystem ("first things to do in Germany as a student"); recurring themes: Ausländerbehörde appointments "fully booked months ahead" (university guides, e.g. KIT, Northeastern); Anmeldung ↔ bank account "chicken and egg" (expats.de, germanycompass.com).
- Competition: university international-office checklists (free, trusted), DAAD/study-in-germany.com portal (free, official-ish), Expatrio/Fintiba (blocked account + insurance bundles — monetised via financial products), content sites (msingermany.com, All About Berlin), VisaFlow, AbroadHub. No dominant neutral, offline, source-linked, personalised app found (INFERENCE, low-confidence absence-of-evidence).

**B. Brazilians → Portugal**
- FACT: 386,463 residence permits issued in 2025; Law 61/2025 changed foreigners law; nationality residency requirement voted 5→10 years on 2026-04-01; plans to end tacit approval (secondary sources: movingto.com, globalcitizensolutions.com, apoiojuridico-imigracao.com).
- INFERENCE: Very high pain, but extremely high rate of policy change and heavy dependence on AIMA case-by-case processing → individual-advice territory. Same language (Portuguese) removes localisation advantage.

**C. Latin Americans → Spain**
- FACT/OFFICIAL: Extraordinary regularisation approved (RD 316/2026); applications 16 April – 30 June 2026 ([La Moncloa](https://www.lamoncloa.gob.es/serviciosdeprensa/notasprensa/inclusion/paginas/2026/proceso-regularizacion-migratoria.aspx)); new Reglamento de Extranjería (RD 1155/2024).
- INFERENCE: Huge one-off demand, but window closed; eligibility is legally sensitive (criminal record, residence proof); strong free NGO support (CEAR, La Merced). High legal risk.

**D. Indians → Canada**
- FACT: Student cap: 408,000 study permits planned for 2026; new student arrivals in 2025 far below target (115,470 vs 305,900) (University Affairs, Canada.ca CIMM notes).
- Competition: Government-funded settlement services network (free), bank newcomer programmes (RBC etc.), settlement.org. Shrinking inflow + strong free incumbents.

**E. Students → Netherlands**
- FACT: ~131,000 international degree students 2024/25; new enrolments flat/declining 2025-26 (Nuffic).
- OFFICIAL: Register with municipality within 5 days (NetherlandsWorldwide). Residence permits for students are typically requested by the institution (INFERENCE from general knowledge; not verified here). Strong "international centre" free services.

**F. Ukrainians → Germany**
- INFERENCE: Temporary-protection rules change by EU/Council decision; strong NGO/government support; low willingness to pay; Ukrainian/Russian localisation would be an advantage but volume of *new* arrivals has fallen (not verified numerically in this run).

**G. Skilled workers → Germany**
- Shares ~70% of task graph with A (registration, tax ID, insurance, broadcasting fee) but employer/relocation agencies often handle steps. Natural **expansion** of A, not beachhead.

## Scoring matrix (1 = poor, 5 = strong for our purpose)

Criteria: 1 volume · 2 digital/community presence · 3 bureaucracy complexity (pain source) · 4 repeatability · 5 authoritative sources · 6 localisation advantage · 7 pain intensity · 8 willingness to pay · 9 competition (5 = weak competition) · 10 creator/community distribution · 11 legal risk (5 = low) · 12 policy stability (5 = stable) · 13 post-arrival admin burden · 14 value without individual legal advice

| | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | **Total** |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| A Students→DE | 4 | 5 | 4 | **5** | **5** | 3 | 4 | 2 | 3 | 5 | **4** | **4** | 4 | **5** | **57** |
| B BR→PT | 4 | 5 | 5 | 2 | 3 | 1 | 5 | 3 | 3 | 5 | 2 | **1** | 4 | 2 | 45 |
| C LatAm→ES | 5 | 4 | 5 | 2 | 4 | 2 | 5 | 2 | 3 | 4 | 1 | 2 | 4 | 2 | 45 |
| D IN→CA | 3 | 5 | 3 | 4 | 5 | 2 | 3 | 3 | 1 | 5 | 4 | 3 | 3 | 4 | 48 |
| E Students→NL | 2 | 4 | 3 | 4 | 4 | 3 | 3 | 2 | 2 | 3 | 4 | 4 | 3 | 4 | 45 |
| F UA→DE | 3 | 4 | 4 | 3 | 4 | 5 | 4 | 1 | 2 | 3 | 3 | 2 | 4 | 3 | 45 |
| G Skilled→DE | 3 | 4 | 4 | 4 | 5 | 3 | 3 | 3 | 3 | 3 | 4 | 4 | 3 | 4 | 50 |

Scores are judgement calls (INFERENCE) informed by the evidence above; they are not measurements.

## Why not optimise for the largest market
C (Spain) and B (Portugal) have the highest raw pain, but their core journeys hinge on individual eligibility decisions and fast-changing law — exactly where a checklist app would drift into legal advice and go stale. A wins on **repeatability**, **source quality**, **stability** and **"value without legal advice"**: nearly every non-EU student on a national study visa performs the same post-arrival sequence with statutory deadlines.

## Result
**Selected: A — non-EU international students (beachhead: students from India) arriving in Germany on a national study visa, first ~90 days.** See `CORRIDOR_SELECTION.md`.
