---
title: "Offline API"
description: "The two symbols that make up the offline API"
order: 21
---

The complete offline surface is two symbols. Everything else about offline mode is handled inside the library.

## `IRKit.prepopulateOfflineData(force, onResult)`

Pre-downloads the offline IRCODE collection so the device can recognize images with no network — no need to open the lens first.

```kotlin
fun prepopulateOfflineData(
    force: Boolean = false,                        // @JvmOverloads — omit in Java for the default
    onResult: (OfflineSyncResult) -> Unit = {}
)
```

| Parameter  | Type                          | Default | Description                                                                                                                                                   |
| ---------- | ----------------------------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `force`    | `Boolean`                     | `false` | When `false`, respects the resync window: if the collection was synced recently, the call is a no-op and returns `Skipped`. Pass `true` to resync regardless. |
| `onResult` | `(OfflineSyncResult) -> Unit` | empty   | Fired on the **main thread** when the sync finishes. Safe to touch UI here.                                                                                   |

### Behavior

- Runs its work on a **background thread**; the call itself does not block.
- Requires `IRKit.initialize(...)` to have run first.
- Safe to call every launch — it self-throttles via the resync window when `force` is `false`.
- Annotated with `@JvmOverloads` so Java callers can omit `force`.

### Kotlin

```kotlin
IRKit.getInstance().prepopulateOfflineData { result ->
    // handle OfflineSyncResult
}

// Or force a refresh:
IRKit.getInstance().prepopulateOfflineData(force = true) { result ->
    // handle OfflineSyncResult
}
```

### Java

```java
IRKit.Companion.getInstance().prepopulateOfflineData(false, result -> {
    // handle OfflineSyncResult
    return kotlin.Unit.INSTANCE;
});
```

## Related Symbols

- [`OfflineSyncResult`](offline-sync-result.md) — sealed result type
