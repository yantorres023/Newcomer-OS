# Final Red Team — "If this app launches tomorrow, how does it cause harm or fail?"

| # | Failure / harm | Class | Likelihood | Severity | Mitigation in V1 | Remaining action |
|---|----------------|-------|-----------|----------|------------------|------------------|
| 1 | A rule was paraphrased wrongly from a search extract (e.g. residence-permit deadline nuance) and a student acts on it | INCORRECT INFORMATION | Medium | **High** | Conservative deadline (day before visa ends), "official source prevails" label, source + last-checked on each task, professional-help sections | **Human source + legal review of all 19 rules before launch** (blocking) |
| 2 | A city changes its application route or URL (Berlin/Munich) and the app points to a dead or outdated page | OUTDATED INFORMATION | High over 6 months | Medium | Link failure fallback (copy link, search by title), last-checked date, report button, validator stale-source warning | Per-semester review; source-monitoring job |
| 3 | Users treat the app as the authority and skip reading their authority's document list | LEGAL TRUST | Medium | High | Documents labelled "commonly requested — check official list"; explanation label; disclaimer; not-government statement everywhere | Comprehension test (VALIDATION_DEBT #3) |
| 4 | Students' actual pain is appointment availability, which the app cannot solve | PRODUCT / MARKET | Medium | Medium | App says "apply even while waiting for an appointment if your authority allows it" and explains the fictional certificate | Interviews; don't over-promise in marketing |
| 5 | Nobody finds it: creators prefer affiliate products; universities are slow | DISTRIBUTION | High | High (business) | Free, ad-free positioning; landing page; content plan | Outreach experiments (VALIDATION_DEBT #11–12) |
| 6 | No revenue: students won't pay, B2B doesn't close | MONETIZATION | High | High (business) | No costly infra (no backend) keeps burn near zero | Fake-door + B2B pilots; STOP/PIVOT gates |
| 7 | Reminder doesn't fire (OS battery optimisation, permission denied, timezone before travel) and a deadline is missed | TECHNICAL | Medium | High | Permission-denied message; in-app Today/overdue view independent of notifications; terms state reminders may not be delivered | Device testing on Android 13–15 and iOS 17–18 |
| 8 | Someone sees immigration details on the lock screen or in the clipboard export | PRIVACY | Low-Medium | Medium | Generic notification text by default; export warning; no cloud backup on Android | iOS backup note in privacy policy |
| 9 | Onboarding misclassifies a user (e.g. Schengen visa holder chooses "national visa"; person with a different residence title) and gets wrong steps | UX / INCORRECT INFORMATION | Medium | High | Visa-sticker "D" help; §81(4) Schengen exclusion noted in fictional-certificate task; professional-help sections | Add "none of these / other situation" exit with referral to authority (next iteration) |
| 10 | German translation reads unnaturally or mistranslates a legal nuance | UX / INCORRECT INFORMATION | Medium | Medium | Official German terms kept verbatim; English is primary | Native-speaker + legal review of `de` content |

## Mitigations applied during this audit
- Made "Overdue" apply only to legal deadlines (suggestions no longer shown as overdue).
- Rundfunkbeitrag date changed to an explicit "our suggestion" 14 days after moving in (no legal date claimed).
- Added null-safety guard on home after data deletion.
- Store copy and dataset guarded by a test against forbidden claims ("guarantee", "official app", "government approved", "never miss").

## Residual material risk
#1 (unreviewed rule content) is the only risk that should **block a public launch**. A closed beta with explicit "pre-release, verify everything" framing is acceptable once item #1's legal-review step has at least covered the residence-permit rules.
