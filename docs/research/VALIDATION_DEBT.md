# Validation Debt

Nothing below has been tested with real users. Each item lists the cheapest test.

| # | Hypothesis | Test | Metric | Pass | Fail | Cheapest test |
|---|-----------|------|--------|------|------|---------------|
| 1 | Newcomers want a sequenced, sourced checklist (not just a blog post) | Closed beta with 30–50 arriving students | Activation (roadmap + 1 task done + 1 source opened in 7 days) | ≥ 40% | < 20% | Post in 3 batch groups / 1 university list |
| 2 | Onboarding is short enough | Beta funnel | onboarding_completed / started | ≥ 80% | < 60% | 5 moderated usability sessions |
| 3 | Users trust the app **and** understand app explanation ≠ official source | Post-task question: "Who decides this deadline?" | % answering "the authority/law" | ≥ 80% | < 60% | 5-user comprehension test |
| 4 | Users open official sources | Beta | % activated users opening ≥ 1 source | ≥ 50% | < 25% | Beta |
| 5 | Users will answer the profile questions (no refusal) | Beta + interviews | Drop-off per question; "prefer not" feedback | No question > 10% drop | Any > 25% | Usability sessions |
| 6 | Users follow the roadmap | Beta | % completing ≥ 5 tasks in 30 days | ≥ 40% | < 15% | Beta |
| 7 | Reminders matter | Beta | % setting ≥ 1 reminder; reminder → task completion | ≥ 30% set | < 10% | Beta |
| 8 | Which tasks create most value | Interviews + task_viewed/completed ranking | Top-3 tasks by value rating | Clear top-3 | Flat | 10 interviews |
| 9 | Students will pay once | Fake-door "Arrival Pack" | Tap-through to price screen | ≥ 5% of activated | < 2% | Fake door |
| 10 | Students would subscribe | Survey (expect no) | Stated WTP | – | – | 1 survey question |
| 11 | Universities will pilot (B2B) | Outreach to 10 international offices | Pilots agreed | ≥ 2 | 0 | 10 emails |
| 12 | Creators will share a non-affiliate tool | 20 creator emails | Features | ≥ 3 | 0 | 20 emails |
| 13 | Information is correct and current | Report-feature + expert review | Confirmed errors per release | 0 critical | ≥ 1 critical at launch → STOP launch | Expert review (see SOURCE_REVIEW_DEBT) |
| 14 | English + German is enough; Hindi/Telugu/Tamil not needed | Interviews | Requests for other languages | < 20% ask | > 40% ask | Survey question |
| 15 | Offline matters | Interviews | Mentions of connectivity problems in week 1 | – | – | Interview question |
| 16 | Other cities need more than finder tools | Beta users outside Berlin/Munich | Activation gap vs Berlin/Munich | Gap < 10 pts | Gap > 25 pts | Beta segmentation |
| 17 | Users return after the first 90 days (renewal) | Long-term | Opens around renewal | – | – | Wait one cycle |

## Beta gates (experimental)
- **Onboarding** ≥ 80% complete profile.
- **Activation** ≥ 40%.
- **Value** ≥ 50% of activated open an official source.
- **Progress** ≥ 40% complete ≥ 5 tasks within 30 days.
- **Retention** ≥ 50% return on ≥ 3 distinct days in first 30 days.
- **Trust** < 1 confirmed incorrect-information report per 50 users; zero critical errors (deadline/permit).

## STOP / PIVOT triggers
- **STOP launch** if any critical rule error is found in expert review and cannot be fixed with a source.
- **PIVOT to B2B white-label** if activation ≥ 40% but WTP < 2% and ≥ 2 universities want pilots.
- **PIVOT to residence-status tracker** if students value renewal/work-day tracking over first-90-days tasks (interviews), or retention collapses after week 3 while renewal interest is high.
- **STOP** if activation < 20% after two iterations **and** no university pilots.
