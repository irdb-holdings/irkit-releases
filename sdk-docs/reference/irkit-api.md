---
title: "IRKit & IRKitUI"
description: "The IRKit and IRKitUI entry points"
order: 11
---

## IRKit (Irkit-library)

| API                                          | Description                                                                                                                |
| -------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| `IRKit.initialize(context, subscriptionKey)` | Set up the SDK (Java: `IRKit.Companion.initialize`). Call as close as possible to opening `IRKitLens` — not at cold start. |
| `IRKit.isInitialized()`                      | Whether initialize already succeeded                                                                                       |
| `IRKit.getInstance()`                        | Access configuration and related helpers after init                                                                        |
| `getConfiguration()`                         | Pass into `IREngine.setConfiguration`                                                                                      |

`IRKitMissingPermissionsException` exposes `missingPermissions: List<String>` when initialize is blocked by permissions.

## IREngine

```kotlin
val irEngine = IREngine(context).apply {
    setConfiguration(IRKit.getInstance().getConfiguration())
}
```

Construct and configure the engine; pass it to `IRKitLens`. You do not need deeper engine APIs for a standard integration.

## IRKitUI (Irkit-ui)

| API                                                | Description                                                 |
| -------------------------------------------------- | ----------------------------------------------------------- |
| `IRKitUI.deInitialize()`                           | Release resources when leaving the lens screen              |
| `IRKitUI.getBuildInfo()` / `getBuildInfo(context)` | Library version, environment, client name for display/debug |
| `IRKitUI.showCredits(context)`                     | Open credits / attributions UI                              |
| `IRKitUI.getEdgeAttributions()`                    | Offline edge OSS attribution text when applicable           |

> **Note:** Prefer `IRKit.initialize` as the entry point for a normal integration.
