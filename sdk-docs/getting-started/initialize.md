---
title: "Initialize IRKit"
description: "Start IRKit once, after permissions are granted and your subscription key is available"
order: 4
---

Call initialize once before opening the scanner, after permissions are granted and your subscription / API key is available. For the no-camera overlay, call [`Tap2Scan.initialize`](../tap2scan/initialize-and-layout.md) instead (before constructing `Tap2ScanLens`) — see [IRKitTap2ScanActivity](../integration/irkittap2scan-activity.md) for the host Activity.

> **Caution:** **Call `IRKit.initialize` as close as possible to opening [`IRKitLens`](../components/irkitlens-overview.md).** Do not initialize at application cold start “just in case.” Initialize when the user is about to enter the scanner (for example, immediately before starting your lens Activity), then open `IRKitLens`.

## Subscription / API Key

Store the key in project-root `local.properties` (do not commit):

```properties
irkitSubscriptionKey=YOUR_KEY_FROM_IRKIT
```

The sample app loads it into `BuildConfig.IRKIT_SUBSCRIPTION_KEY` from `app/build.gradle.kts`. Rebuild after changing the key.

## Kotlin

```kotlin
IRKit.initialize(context, BuildConfig.IRKIT_SUBSCRIPTION_KEY)
```

## Java

```java
IRKit.Companion.initialize(getApplicationContext(), BuildConfig.IRKIT_SUBSCRIPTION_KEY);
```

## Parameters

| Parameter              | Type      | Description                  |
| ---------------------- | --------- | ---------------------------- |
| `context`              | `Context` | Prefer `applicationContext`  |
| `irkitSubscriptionKey` | `String`  | Non-blank API key from IRKit |

## Checks & Errors

- `IRKit.isInitialized()` / `IRKit.Companion.isInitialized()` — already set up?
- `IRKitMissingPermissionsException` — missing camera/location; request then retry
- Blank key — initialize fails; ensure `local.properties` and rebuild

## After Initialize — Build IREngine

```kotlin
val config = IRKit.getInstance().getConfiguration()
val irEngine = IREngine(context).apply {
    setConfiguration(config)
}
// Pass irEngine into IRKitLens
```

## Cleanup

When the user leaves the scanner Activity, call:

```kotlin
override fun onStop() {
    super.onStop()
    IRKitUI.deInitialize()
}
```

Safe if already cleaned up. Call `IRKit.initialize` again before opening the lens on a later visit.
