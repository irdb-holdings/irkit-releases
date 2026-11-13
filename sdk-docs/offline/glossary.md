---
title: "Offline Glossary"
description: "Terms used in the offline docs"
order: 24
---

| Term                       | Meaning                                                                                            |
| -------------------------- | -------------------------------------------------------------------------------------------------- |
| Offline mode               | Recognize IRCODEs with no network by matching against a collection previously synced to the device |
| Sync / prepopulate         | Download or refresh the on-device IRCODE collection via `prepopulateOfflineData`                   |
| `OfflineSyncResult`        | Sealed result: Success, Skipped, NotAvailable, or Failed                                           |
| `force`                    | When `true`, always attempt a sync; when `false`, skip if the local collection is still fresh      |
| Resync window              | Period after a successful sync during which a non-forced call returns `Skipped`                    |
| IRKitLens                  | Compose scanner UI where the camera lives — same host pattern online or offline                    |
| IRCODE collection          | The set of recognizable assets available to your account after sync                                |
| API key / subscription key | Credential passed to `IRKit.initialize`                                                            |
