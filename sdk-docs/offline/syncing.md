---
title: "Syncing"
description: "Download your IRCODE collection onto the device"
order: 17
---

Syncing downloads your IRCODE collection onto the device so the lens can recognize images with no network. You do **not** need to open the lens first — that is the point of `prepopulateOfflineData`.

## Rules of Thumb

- **You must be online to sync.** Syncing downloads the collection, so it needs a connection.
- **Wi-Fi is strongly preferred.** The collection can be sizable; Wi-Fi is faster and avoids using the user’s cellular data. Cellular works — fall back to it only when Wi-Fi isn’t available.
- **Sync before the lens opens.** Good moments: on the screen right before the camera, after permissions and init, or any place you can be sure it finishes before the user taps into the lens.
- **Repeat syncs are cheap.** If the collection was recently synced, calling sync again is a no-op and returns `Skipped` immediately, so it is safe to call every time the app launches (with `force = false`).

## UI While Syncing

- Show a spinner or progress state while sync runs.
- Keep the “open lens” control disabled until the callback fires.
- Handle all four [`OfflineSyncResult`](offline-sync-result.md) cases in the callback.

## `force` — When to Override

| Call                                          | Typical use                                                               |
| --------------------------------------------- | ------------------------------------------------------------------------- |
| `prepopulateOfflineData()` or `force = false` | Production default — skip download if the local collection is still fresh |
| `force = true`                                | Manual “Refresh” / “Sync now” button in a settings or prep screen         |

## Result Summary

| Result         | Meaning for your UI                                                                             |
| -------------- | ----------------------------------------------------------------------------------------------- |
| `Success`      | Collection is ready — enable the lens                                                           |
| `Skipped`      | Already fresh (or sync already running) — enable the lens if you previously synced successfully |
| `NotAvailable` | Offline mode is not enabled for this client — contact IRKit                                     |
| `Failed`       | Show the message, keep lens disabled for offline use, offer retry when online                   |

> **Note:** The callback always runs on the **main thread**. Sync work itself runs in the background and does not block the UI.
