# Red Team — "Newcomer OS is a bad idea"

Selected corridor: non-EU students arriving in Germany (India beachhead).

| # | Attack | Strength | Evidence / reasoning | Response |
|---|--------|----------|----------------------|----------|
| 1 | Government websites already solve it | **Medium** | service.berlin.de, stadt.muenchen.de, DAAD/study-in-germany.com are good per step. But they are per-authority, not a sequenced personal plan; no reminders; German-first city portals. | Don't replace them — link to them. Value = ordering + deadlines + reminders + one place. |
| 2 | Rules change too quickly | **Low-Medium** | Core statutes stable; amounts change (blocked account, broadcasting fee). | Don't store volatile amounts; show last-verified; review workflow. |
| 3 | Information varies by individual | **Medium** | Visa-free nationals, age ≥30 insurance, private insurance exemptions, dependants, Studienkolleg. | Ask 5 selection questions; tasks carry "who it applies to"; out-of-scope situations route to authority/international office. |
| 4 | Users need lawyers, not software | **Low** | Students already hold a visa; follow-up tasks are administrative, not contested. Refusals/irregular stays are out of scope. | Explicit "when to get professional help" in affected tasks. |
| 5 | Liability too high | **Medium** | A wrong deadline could contribute to unlawful stay. | Frame visa expiry rule conservatively ("before your visa expires; apply as early as possible"); never compute legal status; disclaimer; source per task. |
| 6 | Acquisition is expensive | **Medium** | Seasonal, temporary users. Creators monetise via financial referrals. | Distribution via universities/student groups; SEO around deadline questions. Validate cheaply. |
| 7 | Users stop using the app quickly | **High (by design)** | Problem is ~90 days. | Accept: optimise for completion, not DAU. Extension: renewal/work-day tracker, move-city (Ummeldung), post-graduation job-seeker permit. |
| 8 | Communities solve it for free | **Medium-High** | WhatsApp batch groups, seniors, orientation weeks. | Position as companion to community: shareable, sourced, correct. Test whether sourced answers beat group chat. |
| 9 | No recurring revenue | **High** | Temporary problem. | Don't force subscription. B2B licence to universities; one-time pack. Possible STOP trigger if neither validates. |
| 10 | Personalisation too complex | **Low** | ~5 questions select ~20 rules. Deterministic engine. | Keep deterministic, tested. |
| 11 | Maintaining rule data costs too much | **Medium** | ~22 rules + 2 cities ≈ a few hours per semester review; each city adds ~6 links. | Scale cities slowly; source-monitoring design; B2B partners could co-maintain. |
| 12 | Users may trust the app too much | **Medium-High** | Stressed users may treat app as authority. | Each task shows "Official source" vs "Our explanation"; not-government branding; "check your visa sticker" prompts. |

## Additional attacks found
- **Environment limitation:** In this build, official pages could only be read via a search index, not fetched directly. Every rule is flagged `review_required` until a human re-reads the page. (Real risk to launch; not to the thesis.)
- **Seasonality:** 70%+ of arrivals cluster in Aug–Oct (INFERENCE from winter-semester intake) → beta must run in a narrow window.

## Verdict

**GO — with a narrowed thesis.** Not "newcomer OS for everyone", but:

> *"The first-90-days arrival checklist for international students in Germany: personalised deadlines, the official source for every step, private and offline."*

Pivots kept in reserve (same ecosystem):
1. **University white-label onboarding** (B2B) if students won't pay but offices want it.
2. **Residence-status tracker** (visa/permit expiry, work-day counter, renewal, graduate job-search permit) if first-90-days retention is too short.

STOP triggers are defined in `VALIDATION_DEBT.md` and `RELEASE_REPORT.md`.
