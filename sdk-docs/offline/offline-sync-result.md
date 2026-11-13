---
title: "OfflineSyncResult"
description: "What prepopulateOfflineData reports when a sync finishes"
order: 22
---

Sealed type passed to the `onResult` callback of `prepopulateOfflineData`. Exactly four cases.

| Case           | Meaning                                                           | Payload                                                                                                           |
| -------------- | ----------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| `Success`      | Collection synced.                                                | `summary: String` — short human-readable download summary                                                         |
| `Skipped`      | No sync ran — cache still fresh, or a sync was already in flight. | `minutesSinceLastSync: Long` — age of the cached collection (`-1` if it never synced / one was already in flight) |
| `NotAvailable` | Offline mode is disabled for this client.                         | _(none)_                                                                                                          |
| `Failed`       | Sync attempted but failed (no network, server error, etc.).       | `message: String`                                                                                                 |

## Kotlin

```
when (result) {
    is OfflineSyncResult.Success -> {
        // result.summary
    }
    is OfflineSyncResult.Skipped -> {
        // result.minutesSinceLastSync
    }
    is OfflineSyncResult.NotAvailable -> {
        // Offline not enabled for this account
    }
    is OfflineSyncResult.Failed -> {
        // result.message
    }
}
```

## Java

```java
if (result instanceof OfflineSyncResult.Success) {
    String summary = ((OfflineSyncResult.Success) result).getSummary();
} else if (result instanceof OfflineSyncResult.Skipped) {
    long minutes = ((OfflineSyncResult.Skipped) result).getMinutesSinceLastSync();
} else if (result instanceof OfflineSyncResult.NotAvailable) {
    // Offline not enabled for this account
} else if (result instanceof OfflineSyncResult.Failed) {
    String message = ((OfflineSyncResult.Failed) result).getMessage();
}
```

> **Note:** Treat both `Success` and a healthy `Skipped` (collection already on device) as “ready for offline scanning.” Treat `NotAvailable` and `Failed` as “do not rely on offline recognition yet.”
