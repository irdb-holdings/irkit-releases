---
title: "Recommended Flow"
description: "Finish syncing before the camera opens, with a prep screen or an app-start gate"
order: 19
---

Use a prep screen (or app-start gate) so sync always finishes before the camera.

## Suggested Sequence

1. Request camera and location permissions.
2. Call `IRKit.initialize(context, apiKey)` once permissions and the key are ready.
3. Call `prepopulateOfflineData(force = false)` while online.
4. Show progress until `onResult` fires.
5. On `Success` or `Skipped`, enable “Open scanner”.
6. Start your lens Activity / host and show `IRKitLens`.
7. On leave, call `IRKitUI.deInitialize()` as in the main client docs.

## Example: Gate the Open Button

```kotlin
// Kotlin — on a prep / home screen
fun prepareOfflineThenEnableLens() {
    openLensButton.isEnabled = false
    syncProgress.visibility = View.VISIBLE

    IRKit.getInstance().prepopulateOfflineData(force = false) { result ->
        syncProgress.visibility = View.GONE
        when (result) {
            is OfflineSyncResult.Success,
            is OfflineSyncResult.Skipped -> {
                openLensButton.isEnabled = true
                statusText.text = "Ready for offline scanning"
            }
            is OfflineSyncResult.NotAvailable -> {
                statusText.text = "Offline mode is not available for this account"
            }
            is OfflineSyncResult.Failed -> {
                statusText.text = "Sync failed: ${result.message}"
                retryButton.isEnabled = true
            }
        }
    }
}
```

## Example: Java Sync Button

```java
IRKit.Companion.getInstance().prepopulateOfflineData(true, result -> {
    // force = true for an explicit "Sync now" control
    Toast.makeText(this, formatOfflineSyncResult(result), Toast.LENGTH_LONG).show();
    return kotlin.Unit.INSTANCE;
});
```

## When to Sync Again

- **Every launch** with `force = false` — cheap; returns `Skipped` if still fresh.
- **Before a venue event** while on Wi-Fi — ensure the latest collection is on the device.
- **User taps “Sync now”** with `force = true` — always attempts a refresh.

> **Caution:** If sync has never succeeded and the device goes offline, the lens will not have a local collection to match against. Always confirm at least one successful sync before relying on offline use.
