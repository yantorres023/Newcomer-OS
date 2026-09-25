# Erstmal (repo: Newcomer OS)

A private, offline-first Flutter app that gives international students arriving in Germany a personal, ordered checklist of post-arrival administrative steps — each with its official source and last-checked date.

**Status:** MVP built and tested; pre-beta. Not published. Rules need human source/legal review before launch. Start with [`RELEASE_REPORT.md`](RELEASE_REPORT.md).

## Quick start
```bash
flutter pub get
flutter analyze
flutter test                 # 95 tests incl. dataset integrity
flutter run                  # Android emulator / iOS simulator
```
Flutter 3.47.5 stable (pinned in CI).

## Layout
| Path | What |
|------|------|
| `assets/roadmaps/` | Versioned rules + sources dataset (the product's knowledge) |
| `lib/domain/` | Rules engine (pure Dart): conditions, deadlines, dependencies, validator |
| `lib/data/` | Dataset loader, local JSON store with migrations |
| `lib/ui/` | Screens |
| `docs/research/` | Corridor research, evidence ledger, red teams, source corpus, review & validation debt |
| `docs/product/` | Strategy, PRD, UX spec, analytics, brand, disclaimer |
| `docs/engineering/` | Technical plan, rules authoring guide, security & privacy |
| `docs/business/` | Monetization, distribution |
| `legal/` | Draft privacy policy & terms (require legal review) |
| `release/` | Store listing drafts and signing steps |
| `landing/` | Static landing page |

## Editing rules
See [`docs/engineering/RULES_AUTHORING.md`](docs/engineering/RULES_AUTHORING.md). CI rejects datasets that fail validation.

## Disclaimer
Erstmal is an independent project, not affiliated with any government, authority or university. It provides general information, not legal advice.
