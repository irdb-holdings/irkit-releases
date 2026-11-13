---
title: "IRTapToScanView"
description: "A reusable, orientation-aware “tap to scan” overlay that a host app places above its own video player"
---

A reusable, orientation-aware “tap to scan” overlay that a host app places above its own video player.

```swift
@MainActor struct IRTapToScanView
```

## Overview

The host owns the player and the trigger (e.g. a “Shop this scene” button or a long-press); it activates scanning by flipping `isActive` to `true`. The SDK then:

1. runs the scanning animation over the host’s still-playing video,
2. performs recognition as a burst, calling `captureFrame` at each moment of [`tapToScan`](irburstschedule.md#taptoscan) until one attempt matches,
3. presents the orientation-adaptive result takeover (cards / embedded web / Safari) on a match, or a brief “no IRCODE found” hint otherwise,
4. flips `isActive` back to `false` when finished.

While idle the view is fully transparent and ignores hit-testing, so it can live permanently in a `ZStack` above the player (or be applied with the `irTapToScan(...)` modifier).

All recognition, link routing and analytics (session, scan, view, link, product) are handled by the SDK and reuse the same result cards as the live lens.

## Initializers

### init(isActive:subscriptionKey:captureFrame:onResultLinkTapped:onWillPresentExternalContent:onDidDismissExternalContent:onScanStarted:onScanFinished:)

Creates a tap-to-scan overlay.

```swift
@MainActor init(isActive: Binding<Bool>, subscriptionKey: String? = nil, captureFrame: @escaping () -> UIImage?, onResultLinkTapped: ((IRResultLinkTapInfo) -> Bool)? = nil, onWillPresentExternalContent: (() -> Void)? = nil, onDidDismissExternalContent: (() -> Void)? = nil, onScanStarted: (() -> Void)? = nil, onScanFinished: ((Bool) -> Void)? = nil)
```

**Parameters**

- `isActive`: Set to `true` by the host to start a scan; the SDK sets it back to `false` when the experience finishes.
- `subscriptionKey`: Optional lens/subscription key to activate for this scan (per-content lenses). When `nil`, the host’s current IRVision configuration is used.
- `captureFrame`: Returns the player frame to scan, as it is at the moment of the call. Called several times per scan — once per attempt of [`tapToScan`](irburstschedule.md#taptoscan) — so that a burst samples the scene as it moves rather than querying one frame repeatedly. Return `nil` from the first call to abort the scan (the overlay deactivates); `nil` from a later call just skips that attempt.
- `onResultLinkTapped`: Optional host interception of result-card links. Returning `true` skips the SDK’s default navigation.
- `onWillPresentExternalContent`: Called before external web content is shown (host should pause its player).
- `onDidDismissExternalContent`: Called after external web content is dismissed (host should resume its player).
- `onScanStarted`: Called when a scan begins (host may pause its player).
- `onScanFinished`: Called when recognition completes; the `Bool` is `true` on a match.
