---
title: "Capture Modes"
description: "How Tap2Scan gets frames: from your player, or from a provider of your own"
order: 10
---

Your app owns the player. Tap2Scan captures an image from what is on screen and identifies it. Prefer **Host-owned** — you pass the media URI and playhead; the library does the rest. Method signatures: [`Tap2ScanLens` API](tap2scanlens-api.md).

| Name                                                | API                                          | What you do                                                                                                  |
| --------------------------------------------------- | -------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| **[Host-owned](#host-owned-capture)** (recommended) | [`setHostOwnedCapture`](tap2scanlens-api.md) | Pass the URI the player is using and the current playhead. The library captures the image and identifies it. |
| **Default**                                         | (nothing)                                    | The overlay captures from the player already on screen.                                                      |
| **Custom provider**                                 | `setFrameProvider`                           | Advanced: you supply the JPEG (DRM / exotic players)                                                         |

> **Note:** Prefer [`Tap2ScanLens.setHostOwnedCapture`](tap2scanlens-api.md). You do not ship capture or extractor code.

## Host-owned Capture

Tell Tap2Scan which media is playing. Call this after the player view is on screen (see [Initialize & layout](initialize-and-layout.md) or [IRKitTap2ScanActivity](../integration/irkittap2scan-activity.md)).

```
tap2ScanLens.setHostOwnedCapture(
    mediaUri = streamUrl,                 // same URI the player is using
    positionMs = { player.currentPosition },
    onBeforeCapture = { hidePlayerChrome() }, // optional
)
tap2ScanLens.setOnNoMatch { restorePlayerChrome() }
tap2ScanLens.setOnCardsDismissed { restorePlayerChrome() }
```

Types used above: [`Tap2ScanLens`](tap2scanlens-api.md).

### Parameters

| Parameter         | Type            | Description                                                                                                                                                                  |
| ----------------- | --------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `mediaUri`        | `String`        | Same URI/URL the player is playing (required, non-blank)                                                                                                                     |
| `positionMs`      | `() -> Long`    | Playhead in milliseconds, invoked on the main thread at scan time (for example ExoPlayer `currentPosition`)                                                                  |
| `onBeforeCapture` | `(() -> Unit)?` | Optional main-thread hook before capture — hide player chrome so it is not in the captured image. Pass `null` if you have no chrome to hide. Do **not** pause playback here. |

> **Caution:** Do not pause the player in `onBeforeCapture` or `setOnScanStarted`. Leave the video playing during the scan.

You do not need ExoPlayer. Any player that exposes a View plus playhead milliseconds works.

## Custom Provider (Advanced)

`setFrameProvider` lets you supply the JPEG yourself. Use it only for DRM or exotic players. Pass `null` to restore default capture. Prefer host-owned capture for normal apps.
