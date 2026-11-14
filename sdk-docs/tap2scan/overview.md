---
title: "Tap2Scan Overview"
description: "Let viewers tap to scan the video your app is already playing"
order: 8
---

`Tap2Scan` is the **no-camera** IRKit product. Your app owns video or other media playback. The library overlays a scan control, captures a frame from that media, runs recognition, and can deliver an [`ImageModelShared`](../models/imagemodel-shared.md) on success.

> **Note:** Tap2Scan ships inside `com.irdb:irkit-ui` (package `com.irdb.tap2scan`). It is not a separate Maven artifact. Hosts that only need camera [`IRKitLens`](../components/irkitlens-overview.md) still take `irkit-ui`; hosts that only need Tap2Scan still list the four companion AARs.

## IRKitLens vs Tap2Scan

| Concern        | IRKitLens                                                           | Tap2Scan                                                                        |
| -------------- | ------------------------------------------------------------------- | ------------------------------------------------------------------------------- |
| Capture source | Device camera                                                       | Host media player                                                               |
| Host UI        | Embed [`IRKitLens`](../components/irkitlens-overview.md) composable | Embed player + [`Tap2ScanLens`](tap2scanlens-api.md) MATCH_PARENT sibling       |
| Scan trigger   | Continuous live preview                                             | Scan pill tap, long-press (~0.5s) on media, or `triggerScan` / `recognizeImage` |
| Match data     | Observer / optional callbacks                                       | `setOnImageRecognized` → [`ImageModelShared`](../models/imagemodel-shared.md)   |

## Minimal Integration

1. Add `com.irdb:irkit-ui` and the companion AARs as shipped.
2. Call [`Tap2Scan.initialize(context, subscriptionKey)`](initialize-and-layout.md) with a non-blank key **before** constructing `Tap2ScanLens`.
3. Layout: host media view + `Tap2ScanLens` MATCH_PARENT on top (transparent overlay). Idle regions do not steal touches, so player controls keep working.
4. **Recommended:** [`setHostOwnedCapture(mediaUri, positionMs, onBeforeCapture)`](capture-modes.md#host-owned-capture) with the same URI the player uses and playhead milliseconds.
5. Optional: `setOnImageRecognized`, `setOnNoMatch`, `setOnCardsDismissed`.

Do not call `IREngine` from host code for Tap2Scan flows — the lens owns recognition.

## Next

- [IRKitTap2ScanActivity](../integration/irkittap2scan-activity.md) — minimal setup and use
- [Initialize and layout](initialize-and-layout.md)
- [Capture modes — host-owned capture](capture-modes.md#host-owned-capture)
- [Tap2ScanLens API](tap2scanlens-api.md)
