# Product Strategy — Erstmal (working name; repo: Newcomer OS)

## ICP
Non-EU international students who have just arrived (or arrive within ~30 days) in Germany on a national study visa, starting a degree or preparatory course. Beachhead community: students from India (largest origin group, DAAD). Smartphone-first, English-speaking, limited German. V1 city packs: Berlin, Munich; all other cities get federal rules + official finder tools.

## JTBD
"When I land in Germany for my studies, help me get my paperwork done in the right order and before the deadlines, so that I stay legally resident, can enrol, get paid and don't get surprise letters — without having to piece it together from ten websites and WhatsApp groups."

## TRIGGER
Visa granted and flight booked → arrival week → first contact with German bureaucracy (landlord confirmation, Bürgeramt appointment hunt).

## CORE PROMISE
"Know what to do next after arriving in Germany — in the right order, by the right date, with the official source for every step."

## CORE WORKFLOW
Profile (≤ 8 short questions, ~1 minute) → personalised checklist → Today / Upcoming / Done → task detail (what, why, when, what you need, steps, official source, last checked) → mark done / set reminder / add note.

## AHA MOMENT
Seeing the personal date: "Register your address — due 19 Oct (legal deadline)" plus the link to the exact official page for their city.

## ACTIVATION (experimental definition)
Roadmap generated **and** ≥ 1 task completed **and** ≥ 1 official source opened, within 7 days of install.

## RETENTION
The problem is finite (~90 days). Target is completion, not daily use. Retention signals: return visits around deadlines (reminders), completion of the residence-permit application. Long tail: permit renewal reminder (1–3 years later), move/deregistration events.

## MONETIZATION
Free for students in V1. Hypotheses to test (see `docs/business/MONETIZATION.md`): university/student-union licence (B2B2C), one-time "Arrival Pack" unlock, no paid referrals.

## DISTRIBUTION
Creators and communities already serving Indian students going to Germany; university international offices and orientation weeks; student batch groups; SEO for deadline questions (see `docs/business/DISTRIBUTION.md`).

## RISKS
| Risk | Mitigation |
|------|-----------|
| Wrong/outdated rule | Source + last-checked on every task; review workflow; conservative deadlines; dataset validation in CI |
| Over-trust | "Our explanation vs official source" labelling; disclaimer; professional-help sections |
| Short lifecycle | Optimise for completion; B2B revenue; renewal hook |
| Free alternatives | Integrate with (not replace) official pages and university guidance |
| City variation | Only claim city specifics where sourced; others get finder tools |

## VALIDATION DEBT
Everything about real user behaviour is unvalidated — see `docs/research/VALIDATION_DEBT.md`.
