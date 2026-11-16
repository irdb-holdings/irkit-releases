---
title: "Adding Tap-to-Scan Over a Video Player"
description: "Let viewers scan what’s on screen while they keep watching your video, then present IRKit’s result experience as an orientation-adaptive takeover"
order: 5
---

Let viewers scan what’s on screen while they keep watching your video, then present IRKit’s result experience as an orientation-adaptive takeover.

## Overview

Tap-to-scan overlays an IRCODE scanning experience on top of _your own_ video player — live TV/HLS or VOD. Your app owns the player and the trigger (a “Shop this scene” button, a long-press, a remote control action, anything you like). IRKit owns the scanning animation, recognition, and the result presentation.

[`IRTapToScanView`](../reference/irtaptoscanview.md) is a transparent SwiftUI overlay you place above your player. When the viewer activates it, IRKit:

1. runs a scanning animation over the _still-playing_ video (the overlay is transparent, so your video shows through — IRKit does **not** freeze or pause it),
2. performs recognition as a **burst**, calling your `captureFrame` closure at several moments over the next few seconds until one of them matches (see [Capturing the frame](../index.md)),
3. on a match, presents an orientation-adaptive result takeover that reuses the same result cards as [`IRCameraView`](../reference/ircameraview.md) (general / product / art cards, an embedded scan-to-site web view, or a hand-off to an external browser), and
4. on no match, shows a brief “No IRCODE found” hint that dismisses itself.

While idle the overlay is fully transparent and ignores hit-testing, so it can live permanently above the player. Recognition, link routing, and analytics are handled by the SDK, and the result UI is consistent with the live camera experience.

### When to Use It

- **Tap-to-scan** — use it when the viewer is already watching content in _your_ player and you want to make a moment shoppable or informative without sending them to a camera. This is the recommended path for “second screen” / shoppable-video experiences.
- **Live camera lens** ([`IRCameraView`](../reference/ircameraview.md)) — use it when you want IRKit to own a full live camera UI.
- **Burst recognition with your own result UI** ([`identifyImage(schedule:framing:firstFrame:captureFrame:)`](../reference/irvision.md#identifyimagescheduleframingfirstframecaptureframe)) — use it when you want the same multi-frame recognition this overlay performs but intend to present the result yourself. See [Burst recognition without the overlay](../index.md).
- **Still-image recognition** ([`identifyImage(_:)`](../reference/irvision.md#identifyimage_)) — use it when you have a single `UIImage` from a photo picker or your own capture pipeline and want to build a fully custom result UI. See [Recognizing still images](static-image-recognition.md).

## Requirements

- iOS 16.3 or later
- A configured [`IRVision`](../reference/irvision.md) instance (see [Configuring IRKit](configuration.md))

## Configuration

Tap-to-scan recognizes images against whatever lens [`IRVision`](../reference/irvision.md) is configured with. Configure it once at startup (or before entering the player) with your subscription key:

```swift
import IRKit

let configuration = IRVisionConfiguration(subscriptionKey: "your-subscription-key")
IRVision.configure(with: configuration)
```

If a single piece of content should be matched against a _different_ lens, pass `subscriptionKey` per scan instead of reconfiguring — see [Per-content lenses](../index.md) below.

## Quick Start

Drive the overlay from a `Bool` your app owns. Set it to `true` to start a scan; the SDK sets it back to `false` when the experience finishes (a dismissed result, or an auto-dismissed no-match).

```swift
import SwiftUI
import IRKit

struct PlayerScreen: View {
    @State private var isScanning = false
    @StateObject private var player = MyVideoPlayer()

    var body: some View {
        ZStack {
            MyVideoView(player: player)

            // Host-owned trigger.
            Button("Shop this scene") { isScanning = true }
        }
        .irTapToScan(
            isActive: $isScanning,
            captureFrame: { player.currentFrame() }   // -> UIImage?
        )
    }
}
```

The video keeps playing behind the transparent scanning overlay. Add the lifecycle hooks below only if you want to react to scanning, results, or external content.

> **Tip:** For live HLS streams, capture frames with `AVPlayerItemVideoOutput` rather than `AVAssetImageGenerator`, which is unreliable for streaming content. Apply the track’s preferred transform so the captured `UIImage` is upright.

## Capturing the Frame

`captureFrame` is called **once per burst attempt**—eight times over about 4.5 seconds by default—and always on the main actor. Return the frame as it is at the moment of the call.

Because your video keeps playing, each attempt samples a _different_ moment of the scene. Attempts overlap rather than queue and stop at the first hit, so a quick match can finish early. The default burst may continue for up to 12 seconds when no match is found.

Returning `nil` from the **first** call aborts the scan — the overlay deactivates immediately without scanning (and flips `isActive` back to `false`). Returning `nil` from a later call just skips that one attempt, which is the right answer when no new frame has been decoded yet.

Keep the closure cheap. It runs on the main actor, so do not decode, resize, or re-encode anything in it beyond copying the current frame — the SDK builds the query image off the main thread.

```swift
.irTapToScan(
    isActive: $isScanning,
    captureFrame: {
        let time = player.currentTime()
        guard videoOutput.hasNewPixelBuffer(forItemTime: time),
              let buffer = videoOutput.copyPixelBuffer(forItemTime: time,
                                                       itemTimeForDisplay: nil) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: buffer)
        guard let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
)
```

## Per-content Lenses

If a host associates a different lens with each piece of content (for example a live-news lens versus a shoppable-VOD lens), pass `subscriptionKey`. The SDK switches the active lens in place for that scan without tearing down the rest of your [`IRVisionConfiguration`](../reference/irvisionconfiguration.md).

```swift
.irTapToScan(
    isActive: $isScanning,
    subscriptionKey: content.subscriptionKey,
    captureFrame: { player.currentFrame() }
)
```

When `subscriptionKey` is `nil`, the overlay uses whatever lens your app last configured on [`IRVision`](../reference/irvision.md).

## Lifecycle Hooks and Controlling Playback

The overlay never touches your player — IRKit does **not** pause, freeze, or resume playback. The video continues playing through the transparent scanning overlay and behind the dimmed result takeover. If you _want_ to pause (for example to avoid spoilers behind the result panel, or to mute audio while a web view is open), do it yourself in these hooks:

- `onScanStarted` — fired when a scan begins (after the first frame is captured). You _can_ pause here, but prefer not to: the burst’s later attempts exist to sample the scene as it moves, and a paused player hands every attempt the same frame.
- `onScanFinished(Bool)` — fired when recognition completes; the `Bool` is `true` on a match, `false` on a no-match.
- `onWillPresentExternalContent` — fired right before the result opens external web content (an in-app Safari sheet, an `openInNewWindow` link, or a deep link). Pause the player here.
- `onDidDismissExternalContent` — fired after that external content is dismissed. Resume the player here.
- You can also observe `isActive` flipping back to `false` to resume playback once the whole experience finishes.

```swift
.irTapToScan(
    isActive: $isScanning,
    captureFrame: { player.currentFrame() },
    onWillPresentExternalContent: { player.pause() },
    onDidDismissExternalContent: { player.play() },
    onScanStarted: { /* optional: player.pause() */ },
    onScanFinished: { matched in print("matched: \(matched)") }
)
```

## Intercepting Result Links

Result-card links, scan-to-site actions, and product taps can be intercepted exactly as they are for [`IRCameraView`](../reference/ircameraview.md). Provide `onResultLinkTapped`; return `true` to suppress IRKit’s default navigation (you’ll handle the destination yourself), or `false` to let IRKit navigate. Either way, IRKit emits its own analytics for the tap first.

```swift
.irTapToScan(
    isActive: $isScanning,
    captureFrame: { player.currentFrame() },
    onResultLinkTapped: { info in
        switch info.kind {
        case .product:
            route(to: info.url)   // handle in-app
            return true           // skip IRKit's default navigation
        case .link, .scanToSite:
            return false          // let IRKit open it
        }
    }
)
```

The closure receives an [`IRResultLinkTapInfo`](../reference/irresultlinktapinfo.md) describing the tap — its `kind` (`link` / `scanToSite` / `product`), `source`, resolved `url`, original `urlString`, optional `title`/`icon`, and the recognized image’s `imageID` and preview text. For a full discussion of link kinds and sources, see [Intercepting result links](link-interception.md).

## Orientation

The result takeover adapts to the device orientation; no host configuration is required.

- **Portrait** — a standard result card anchored to the bottom of the screen, the same card the live lens shows.
- **Landscape** — a frosted (`.ultraThinMaterial`) side panel docked to the trailing edge, sized to a column so the player stays visible behind a dimmed backdrop. The panel’s trailing corners are matched to the device’s physical screen-corner radius so it reads as a natural extension of the display edge.

## Dismissal

The viewer dismisses the result without any close button:

- **Swipe** — in portrait, the card’s own swipe-down gesture; in landscape, a left-to-right swipe slides the panel off the trailing edge.
- **Tap the backdrop** — tapping the dimmed area behind the card dismisses it.

During the **scanning** phase a small cancel (✕) button is shown in the top corner so the viewer can back out before a result appears. A **no-match** hint dismisses itself after a couple of seconds (or on tap). In every case the SDK flips `isActive` back to `false` when the experience ends.

## Using the View Directly

`irTapToScan(...)` is a convenience wrapper over [`IRTapToScanView`](../reference/irtaptoscanview.md) and is the recommended entry point. If you need finer control over layering, place the view in a `ZStack` yourself — it takes the same parameters:

```swift
ZStack {
    MyVideoView(player: player)
    IRTapToScanView(
        isActive: $isScanning,
        captureFrame: { player.currentFrame() }
    )
}
```

## Burst Recognition Without the Overlay

If you want IRKit’s recognition but your own result UI, call the burst directly. It takes the same closure and returns the recognized [`ImageModel`](../reference/imagemodel.md) (or `nil`), with no views involved:

```swift
let match = await IRVision.shared.identifyImage(
    firstFrame: player.currentFrame(),
    captureFrame: { player.currentFrame() }
)
```

Pass a custom [`IRBurstSchedule`](../reference/irburstschedule.md) to change how long a scan may look and how often it samples. Fewer attempts mean fewer network requests but may reduce the chance of matching content that has only recently become available:

```swift
let quick = IRBurstSchedule(offsetsMs: [0, 750, 1500], deadline: 6)
let match = await IRVision.shared.identifyImage(schedule: quick) { player.currentFrame() }
```

[`IRQueryFraming`](../reference/irqueryframing.md) controls how each frame becomes a query image. The default, [`IRQueryFraming.fullFrame`](../reference/irqueryframing.md#irqueryframingfullframe), sends the whole frame and suits already-composed content. Pass [`IRQueryFraming.foveated`](../reference/irqueryframing.md#irqueryframingfoveated) when the source is a camera scene rather than a player: it stacks three zoom levels of the frame’s centre square, which finds a subject sitting at an unknown scale but discards everything outside that square.
