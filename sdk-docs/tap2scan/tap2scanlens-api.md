---
title: "Tap2ScanLens API"
description: "The Tap2ScanLens composable's API"
order: 11
---

Package: `com.irdb.tap2scan`. Attach `Tap2ScanLens` as a MATCH_PARENT sibling above the host video player after [`Tap2Scan.initialize`](initialize-and-layout.md).

## Recommended Capture & Results

| API                    | Signature                                                                    | Description                                                                                                                                               |
| ---------------------- | ---------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `setHostOwnedCapture`  | `(mediaUri: String, positionMs: () -> Long, onBeforeCapture: (() -> Unit)?)` | Preferred. Pass the URI and playhead; the library captures the image and identifies it. Guide: [Host-owned capture](capture-modes.md#host-owned-capture). |
| `setOnImageRecognized` | `(listener: ((ImageModelShared) -> Unit)?)`                                  | Main-thread callback after a successful match. Clear with `null` when leaving the screen if the lambda captures an Activity.                              |
| `setOnNoMatch`         | `(listener: (() -> Unit)?)`                                                  | Main-thread callback when recognition finishes with no match. Typical: restore player chrome.                                                             |
| `setOnCardsDismissed`  | `(listener: (() -> Unit)?)`                                                  | Main-thread callback when match cards close (user dismiss, system back, or microsite handoff).                                                            |

## Scan Control

| API                    | Signature                      | Description                                                                                               |
| ---------------------- | ------------------------------ | --------------------------------------------------------------------------------------------------------- |
| `setScanButtonVisible` | `(visible: Boolean)`           | Show or hide the built-in pill. Default `true`. When hidden, long-press (~0.5s) on the media still scans. |
| `setButtonStyle`       | `(style: Tap2ScanButtonStyle)` | Full visual / layout override for the scan pill.                                                          |
| `setScanButtonPadding` | `(topDp: Float, endDp: Float)` | Java-friendly top/end outer padding. Top is measured from below the status bar when it is visible.        |
| `triggerScan`          | `()`                           | Same path as tapping the scan pill (also used by long-press).                                             |
| `recognizeImage`       | `(jpeg: ByteArray)`            | Run recognition on host-supplied JPEG bytes without capturing.                                            |
| `dismissActiveCards`   | `(): Boolean`                  | `true` if a card stack was dismissed; `false` if nothing was showing.                                     |

## Optional Host Hooks

These are additive — `setOnImageRecognized` / `setOnNoMatch` still fire.

| API                               | Signature                                         | When it fires                                                                                                                   |
| --------------------------------- | ------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| `setOnScanStarted`                | `(listener: (() -> Unit)?)`                       | After a frame is captured, before recognition runs. Do not pause playback here — leave the video playing during the scan.       |
| `setOnScanFinished`               | `(listener: ((Boolean) -> Unit)?)`                | Recognition complete — `true` match, `false` no match / error                                                                   |
| `setOnWillPresentExternalContent` | `(listener: (() -> Unit)?)`                       | Right before a link hands off to an external app/browser — pause your player here                                               |
| `setOnDidDismissExternalContent`  | `(listener: (() -> Unit)?)`                       | On the host Activity’s next resume after the above — resume your player here                                                    |
| `setOnResultLinkTapped`           | `(listener: ((Tap2ScanLinkTapInfo) -> Boolean)?)` | Before a result-card link navigates. Return `true` to handle the destination yourself; `false` / `null` lets Tap2Scan navigate. |
| `setOnActiveChanged`              | `(listener: ((Boolean) -> Unit)?)`                | Optional two-way experience flag: `true` while capture / scan / result is live                                                  |
| `isActive`                        | `Boolean`                                         | Read-only snapshot of that flag                                                                                                 |
| `setActive`                       | `(active: Boolean)`                               | `true` starts a scan (same as `triggerScan`); `false` cancels / dismisses                                                       |

## Advanced (Secondary)

| API                | Description                                                                                                                                 |
| ------------------ | ------------------------------------------------------------------------------------------------------------------------------------------- |
| `setFrameProvider` | Advanced custom JPEG supplier. Prefer [`setHostOwnedCapture`](capture-modes.md#host-owned-capture). Pass `null` to restore default capture. |
| `setCaptureTarget` | Optional override when auto-discovery cannot find the media surface. Most hosts never need this.                                            |
| `setHostWindow`    | Optional override for the host Activity window. Resolved from the hosting Activity when unset. Most hosts never need this.                  |

## Tap2ScanOverlay

Optional Compose sibling with the same recognition path. Long-press-to-scan is on **`Tap2ScanLens`**, not the overlay.
