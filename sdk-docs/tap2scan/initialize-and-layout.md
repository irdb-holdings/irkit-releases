---
title: "Initialize and Layout"
description: "Start Tap2Scan and lay its lens over your player"
order: 9
---

Initialize [`Tap2Scan`](overview.md) with your subscription key, then overlay [`Tap2ScanLens`](tap2scanlens-api.md) on top of your media player. For the full Activity host pattern (minimal setup and use), see [IRKitTap2ScanActivity](../integration/irkittap2scan-activity.md).

> **Caution:** **Call `Tap2Scan.initialize` before constructing `Tap2ScanLens`.** The subscription key is required and must be non-blank. If [`IRKit`](../reference/irkit-api.md) is not already initialized, Tap2Scan bootstraps it with the same key.

## Tap2Scan.initialize

| API                                             | Description                                                                                                                           |
| ----------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| `Tap2Scan.initialize(context, subscriptionKey)` | Required. Retains the application context. Fails fast if the key is blank, or if IRKit is already initialized with a _different_ key. |
| `Tap2Scan.isInitialized`                        | Whether initialize already succeeded                                                                                                  |
| `Tap2Scan.libraryVersion`                       | Optional: library version string for display or support                                                                               |

## Recommended Sample

```
Tap2Scan.initialize(context, subscriptionKey)

// After PlayerView (or other media View) is on screen:
tap2ScanLens.setHostOwnedCapture(
    mediaUri = streamUrl,
    positionMs = { player.currentPosition },
    onBeforeCapture = { hidePlayerChrome() },
)
tap2ScanLens.setOnNoMatch { restorePlayerChrome() }
tap2ScanLens.setOnCardsDismissed { restorePlayerChrome() }
tap2ScanLens.setOnImageRecognized { shared: ImageModelShared ->
    // imageID, previewTitle, products, …
}
```

Types used above: [`Tap2ScanLens`](tap2scanlens-api.md), [`ImageModelShared`](../models/imagemodel-shared.md).

## Layout

Put your media view on screen, then add `Tap2ScanLens` as a MATCH_PARENT sibling on top. The overlay is transparent. Idle regions do not consume touches, so player controls keep working.

- When the host window is edge-to-edge, apply navigation-bar insets to **the overlay**, not the player — keep video full-bleed.
- The SCAN pill still offsets for the status bar internally.
- A ~0.5s long-press on the media view triggers the same scan path as the pill. Quick taps do not scan.

## Optional Compose Overlay

`Tap2ScanOverlay` is an optional Compose sibling with the same recognition path. Long-press-to-scan is on **`Tap2ScanLens`**, not the overlay. Prefer the View API for traditional hosts.

## Next

- [IRKitTap2ScanActivity](../integration/irkittap2scan-activity.md) — minimal setup and use
- [Capture modes — host-owned capture](capture-modes.md#host-owned-capture) (recommended)
- [Scan pill appearance](button-style.md)
