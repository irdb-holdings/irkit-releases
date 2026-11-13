---
title: "Sample Walkthrough"
description: "The offline-capable reference app, step by step"
order: 20
---

Working reference code lives in the offline-capable sample app. Use it as a copy-from host: Java/XML shell, sync button, and Kotlin `IRKitLensActivity`.

## Where Each Piece Lives

| Part               | Where                                                                                       |
| ------------------ | ------------------------------------------------------------------------------------------- |
| Initialize IRKit   | `MainActivity.java` — `ensureIrkitInitialized()` calls `IRKit.initialize(...)`              |
| Sync offline data  | `MainActivity.java` — `onSyncClicked()` calls `prepopulateOfflineData(...)`                 |
| Handle sync result | `MainActivity.java` — `formatOfflineSyncResult()` covers all four `OfflineSyncResult` cases |
| Open the lens      | `IRKitLensActivity.kt` — hosts the `IRKitLens` composable                                   |

## What the Sample Demonstrates

1. Permissions and subscription key checks before any IRKit call.
2. Lazy initialize shared by both Sync and Open Lens actions.
3. A Sync control that uses `force = true` so testers always trigger a refresh.
4. Toast / status messaging for each `OfflineSyncResult`.
5. Standard lens hosting after prep is done.

> **Note:** In production, prefer `force = false` on automatic syncs (app launch / prep screen). Reserve `force = true` for an explicit “Sync now” control, as the sample’s button does.

## Minimal Sync Handler (Java)

```java
private static String formatOfflineSyncResult(OfflineSyncResult result) {
    if (result instanceof OfflineSyncResult.Success) {
        return "Synced — " + ((OfflineSyncResult.Success) result).getSummary();
    }
    if (result instanceof OfflineSyncResult.Skipped) {
        return "Skipped — catalog fresh ("
                + ((OfflineSyncResult.Skipped) result).getMinutesSinceLastSync() + "m ago)";
    }
    if (result instanceof OfflineSyncResult.NotAvailable) {
        return "Offline mode not available for this client";
    }
    return "Failed — " + ((OfflineSyncResult.Failed) result).getMessage();
}
```
