# UX Spec — Erstmal V1

Design principle: a stressed, tired newcomer using a second language must be able to answer **What do I do? Why? When? What do I need? Where is the official source? What's next?** within seconds.

## 1. Welcome & disclaimer (first run)
- App name, promise ("Your first 90 days in Germany, step by step"), one-paragraph explanation.
- "Independent app, not a government service" + "No account, answers stay on this phone".
- Language selector (Device / English / Deutsch).
- Disclaimer card (short, readable, not scary). Single CTA "I understand — start". Versioned: bumping `disclaimerVersion` re-shows it.

## 2. Onboarding / profile questions
One question per screen, progress bar ("Question 2 of 7"), each with a "Why we ask" line. Next disabled until answered; back works (app bar + system back).
1. How did you enter Germany? national visa / visa-free / EU-EEA-CH (+ help: the "D" on the visa sticker).
2. What are you starting? degree / preparatory course.
3. Where will you live? Berlin / Munich / another city (+ explanation for other).
4. Arrival date (date picker).
5. Move-in date for long-term home, or "I don't have one yet".
6. Visa end date (national visa only), or "add later".
7. Toggles: 30 or older; plan to work; family coming.
8. Summary: "N tasks selected" + list. CTA "See my checklist".
Not asked: name, nationality, passport/visa numbers, exact age, university, address.

## 3. Home (roadmap)
- App bar: title, Sources, Settings.
- Header: "4 of 15 done" + progress bar + "Next deadline: 19 Oct · Register your address".
- Tabs: **Today** · **Upcoming** · **Done**. Upcoming ends with section "When it happens" (move, leaving Germany).
- Task card: checkbox (labelled), title, timing line ("Due in 5 days", "Overdue since …", "Suggested by …", "Follow up on …", "Add your move-in date to see the deadline"), chips with icon+text: Overdue, "First: <blocking task>", Practical tip, Updated since completed, No longer applies, Reminder.

## 4. Task detail
Order: title → kind chip → summary (+ "our explanation; official source prevails") → **When** (date + basis: legal / official guidance / our suggestion; suggested start; edit-dates shortcut if missing) → **Do this first** (hard deps; soft "usually easier after") → **Why this matters** → **Steps** (numbered) → **What you need** (official vs commonly requested) → **Official source** cards (title in original language, authority, government vs publicly-funded label, last checked, pending re-check flag, Open / Copy link, "needs internet") → **Words you will see** (German terms) → **Good to know** → **When to get individual help** → **Why you see this** → **Reminder** → **My notes** (warning not to store ID numbers) → Mark as done / not done (+ "I've checked the update" if rule changed) → Report outdated info (copies a report with no personal data).

## 5. Official-source opening
External browser, https only, dataset URLs only. On failure: snackbar explaining copy-link and "search the authority's site for the title" — never redirect to an unofficial alternative.

## 6. Reminders
Bottom sheet: 1 week before date, 1 day before, tomorrow, pick a date. 09:00 local time. Permission requested at first use; denial explained. Default text is generic ("You have a checklist task coming up"); Settings toggle to show task names. Reminder cancelled automatically when a task is completed or no longer applies.

## 7. Settings
Your situation (answers + dates incl. residence card expiry) → Edit answers; Language; Notifications privacy toggle; Sources; Disclaimer; Privacy summary; data version; Copy my data; Delete all my data (confirm dialog).

## 8. Language
Device language by default; EN/DE override. Content falls back to English with a visible notice if a translation is missing.

## 9. Disclaimer placements
Welcome (full), Settings (full), each task (one-line "our explanation" label), professional-help sections, store listing, landing page.

## 10. Error states
- Dataset invalid → full-screen error; points to city websites and university international office.
- Corrupt local data → banner "started fresh; copy kept".
- Save failed → persistent banner.
- Link failed → snackbar with fallback.
- Task disappeared (profile changed while open) → "No longer applies".

## 11. Offline states
Everything except opening official pages works offline (bundled dataset, local storage, local notifications). Source cards say "needs internet".

## 12. Empty states
Today: "Nothing urgent right now. Look at Upcoming…". Upcoming: "Nothing scheduled later." Done: "Tasks you mark as done appear here."

## 13. Accessibility
Semantic headers on section titles; checkbox semantic labels; status conveyed by icon + text; text scale to 200% without overflow (tested); Material tap targets ≥ 48dp (guideline-tested); text contrast guideline-tested; plain-language copy (short sentences, German terms explained).
