---
title: "Setup"
description: "What to set up before a device can recognize offline"
order: 16
---

Offline mode is enabled for your account — there is no flag for you to turn on. You only need two things: initialize IRKit, then run a sync while online before showing the lens.

## 1. Initialize IRKit

Use the same initialize call as a normal integration, with your IRKit-issued subscription / API key:

```java
// Kotlin
IRKit.initialize(context, subscriptionKey)

// Java
IRKit.Companion.initialize(getApplicationContext(), subscriptionKey);
```

Permissions (camera, location) and a non-blank key are still required. See [Initialize IRKit](../getting-started/initialize.md) for the full host pattern.

> **Note:** For offline apps, initialize early enough that you can finish a sync **before** the user opens the lens (for example on the screen before the camera, or right after the user grants permissions). Do not open `IRKitLens` until sync has completed.

## 2. Run a Sync

A single call downloads (or refreshes) the on-device IRCODE collection:

```kotlin
IRKit.getInstance().prepopulateOfflineData { result ->
    // result: OfflineSyncResult — fired on the main thread when the sync finishes
    // e.g. enable the "open lens" button here
}
```

### Java

```java
IRKit.Companion.getInstance().prepopulateOfflineData(false, result -> {
    // Handle OfflineSyncResult on the main thread
    return kotlin.Unit.INSTANCE;
});
```

> **Caution:** **Java callback:** The Kotlin lambda returns `Unit`. From Java, return `kotlin.Unit.INSTANCE` from the callback.

## What Sync Needs

- `IRKit.initialize(...)` must have succeeded first.
- The device must be online to download the collection.
- Wi-Fi is strongly preferred (the collection can be sizable).

## Then Open the Lens

Host `IRKitLens` as usual. After a successful or skipped sync (cache already fresh), the lens can recognize against the local collection even with no network.
