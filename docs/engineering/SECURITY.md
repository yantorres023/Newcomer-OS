# Security & Privacy Review — V1

## Threat model (short)
Assets: a user's immigration-related situation (entry type, dates, family, work plans), notes. Adversaries: someone with physical access to the unlocked/locked phone; other apps; cloud backups; a malicious link; a tampered dataset.

## Review
| Area | Finding | Status |
|------|---------|--------|
| Local data | One JSON file in app-private support directory (`getApplicationSupportDirectory`). Not encrypted beyond OS file-based encryption. | Acceptable for V1 given data minimisation. Consider encryption if a document vault is ever added. |
| Sensitive profile fields | Only categorical answers + 4 dates; no name, nationality, passport/visa/tax numbers, images. | ✅ minimised |
| Notes | Free text could contain sensitive data. Hint warns not to store ID numbers; 1000-char limit. | ✅ mitigated |
| Logs | No logging of profile/notes. Analytics sink prints only in debug builds and never receives profile values (tested). Timezone failure logs only exception type. | ✅ |
| Notifications | Default generic text on lock screen; Android visibility `private`; opt-in to show task names. | ✅ |
| Deep links | None registered. | ✅ |
| External URLs | Only https URLs present in the bundled dataset can be opened; external browser; tested against `http`, `javascript:`, `intent:`, foreign hosts. | ✅ |
| Dataset integrity | Bundled asset; validated at load; invalid dataset → error screen. No remote loading. | ✅ |
| Backups | Android `allowBackup=false`, data-extraction rules exclude cloud backup and device transfer. iOS: app support dir is included in iCloud/device backups by default (encrypted backups) — acceptable; document in privacy policy. | ⚠️ iOS noted |
| Deletion | "Delete all my data" removes the file, temp and quarantine copies and cancels notifications. Uninstall removes everything. | ✅ tested |
| Export | Copies JSON to clipboard with warning. Clipboard may be read by other apps/keyboards. | ⚠️ acceptable, warned |
| Corrupt data | Quarantined copy kept locally (deleted by delete-all). | ✅ |
| Debug config | `debugShowCheckedModeBanner: false`; no debug endpoints; release builds debug-signed until owner key exists (not uploadable). | ⚠️ signing pending |
| Permissions | Android: POST_NOTIFICATIONS, RECEIVE_BOOT_COMPLETED only. No INTERNET permission in main manifest (Flutter adds it in debug only); links open in browser. iOS: notification permission only. | ✅ |
| Third-party SDKs | None beyond Flutter plugins (notifications, timezone, url_launcher, path_provider). No ads/analytics/crash SDKs. | ✅ |
| Supply chain | `pubspec.lock` committed; CI pins Flutter version. | ✅ |

## Privacy data map
| Data | Why | Location | Retention | Deletion | Sharing |
|------|-----|----------|-----------|----------|---------|
| Entry type, study stage, city | Select rules and sources | Device (JSON) | Until user deletes/uninstalls | Settings → Delete / uninstall | None |
| Arrival, move-in, visa-end, card-expiry dates | Compute deadlines | Device | same | same | None |
| Age ≥ 30, plans to work, family joining (booleans) | Select rules | Device | same | same | None |
| Completion records (rule id, version, date) | Progress, rule-update flags | Device | same | same | None |
| Notes | User's own memory aid | Device | same | same | None |
| Reminders (rule id, date, notification id) | Local notifications | Device + OS notification scheduler | Until fired/cancelled | Cleared on completion/delete | None |
| Settings (language, notification privacy, disclaimer version) | Preferences | Device | same | same | None |
| Opened URLs | Show official page | User's browser | Browser's policy | Browser | The authority's website receives a normal visit |

No data is transmitted by the app. No account. No server.
