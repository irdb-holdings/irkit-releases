---
title: "Offline Recognition"
description: "Recognize IRCODE-enabled images on-device using an optional, host-integrated recognition engine"
order: 8
---

Recognize IRCODE-enabled images on-device using an optional, host-integrated recognition engine.

## Overview

Offline recognition lets your host app recognize campaign images without a network round trip—for example, in venues with limited connectivity. It is powered by an **optional on-device engine** that you integrate and register with IRKit at runtime.

The capability is fully **opt-in**: a host that does not integrate an engine runs online-only. When the engine is integrated and enabled, the live camera and still-image flows can use it when the online service is unavailable.

Offline matches are returned as [`ImageModel`](../reference/imagemodel.md) values. The fields available in a result depend on the data supplied by the registered engine.

## How It Fits Together

```
Host app                                   IRKit SDK
────────                                   ─────────
create an engine that conforms to the protocol
   │
   ├─ IRVision.registerOfflineRecognitionEngine(engine)
   │                                       isOfflineEngineAvailable
   ├─ await IRVision.setOfflineEngineEnabled(true)
   │        └── validates the engine ─────▶ offlineEngineStatus
   └─ try await IRVision.syncOfflineIRCodes(force:onProgress:)
                                            recognition can use local data
```

## Integrate an Engine

IRKit defines the [`IROfflineRecognitionEngine`](../reference/irofflinerecognitionengine.md) protocol. The host provides a concrete implementation and registers it with IRKit.

1. **Add the IRKit SDK** via Swift Package Manager.
2. **Implement** [`IROfflineRecognitionEngine`](../reference/irofflinerecognitionengine.md) in your app or an engine package.
3. **Register and enable** the engine at runtime, then sync the local data:

```swift
import IRKit

// 1. Register the adapter (no-op if the package isn't linked).
IRVision.registerOfflineRecognitionEngine(MyOfflineRecognitionEngine())

// 2. Configure IRKit as usual.
IRVision.configure(with: configuration)

// 3. Enable + preflight, then sync if ready.
Task {
    let status = await IRVision.setOfflineEngineEnabled(true)
    guard status == .ready else { return }   // stays online-only otherwise
    try? await IRVision.shared.syncOfflineIRCodes(force: true)
}
```

## Availability and Validation

Because the engine is optional, the SDK gates every offline path behind a runtime availability check and never crashes when the package is absent:

- **Presence is registration.** [`isOfflineEngineAvailable`](../reference/irvision.md#isofflineengineavailable) is `true` only after a host calls [`registerOfflineRecognitionEngine(_:)`](../reference/irvision.md#registerofflinerecognitionengine_).
- **Enabling runs a preflight.** [`setOfflineEngineEnabled(_:)`](../reference/irvision.md#setofflineengineenabled_) persists the toggle and runs a one-time check that the engine actually constructs and loads on this device. It returns an [`IROfflineEngineStatus`](../reference/irofflineenginestatus.md):

  - [`IROfflineEngineStatus.ready`](../reference/irofflineenginestatus.md#irofflineenginestatusready) — offline recognition is active.
  - [`IROfflineEngineStatus.unavailable(_:)`](../reference/irofflineenginestatus.md#irofflineenginestatusunavailable_) with `IROfflineEngineUnavailableReason.notIntegrated` (no engine registered) or `IROfflineEngineUnavailableReason.preflightFailed` (the engine couldn’t initialize).
  - [`IROfflineEngineStatus.notEnabled`](../reference/irofflineenginestatus.md#irofflineenginestatusnotenabled) — the toggle is off.

- **Hard gate.** The live and snapshot pipelines run the engine only when the toggle is on _and_ the status is `.ready`. Otherwise the SDK stays online-only.
- **Observe changes.** [`offlineEngineStatus`](../reference/irvision.md#offlineenginestatus) is published via `Notification.Name.irkitOfflineEngineStatusChanged` so your UI can reflect availability.

```swift
switch await IRVision.setOfflineEngineEnabled(true) {
case .ready:
    // good to sync + recognize on-device
case .unavailable(.notIntegrated):
    // engine package not in this build — online only
case .unavailable(.preflightFailed):
    // engine present but couldn't start — online only
case .notEnabled:
    break
}
```

## Sync Local Data

The host drives synchronization; IRKit forwards the call to the registered engine. Use [`syncOfflineIRCodes(force:onProgress:)`](../reference/irvision.md#syncofflineircodesforceonprogress) to prepare local data and drive a progress UI. Progress callbacks are delivered on the main thread.

```swift
try await IRVision.shared.syncOfflineIRCodes(force: true) { progress in
    switch progress.phase {
    case .manifest:    // totals unknown yet — show an indeterminate spinner
        break
    case .downloading: // determinate
        updateBar(progress.fractionCompleted)
    case .finished, .failed:
        break
    }
}
```

The returned [`IROfflineSyncStats`](../reference/irofflinesyncstats.md) summarizes the outcome (`entriesAdded`, `entriesRemoved`, `failures`, `totalLocalRecords`, `aborted`) for logging or UI.

### When to Sync

The host decides when to sync; IRKit never syncs on its own. Common triggers:

- **On entering an offline-enabled experience.** Start a forced sync so local data is ready by the time the user scans.
- **App foreground.** Refresh from `applicationDidBecomeActive(_:)` (or the SwiftUI `scenePhase` becoming `.active`) when returning to the app.
- **Silent push.** Call with `force: true` from your remote-notification handler when your app receives a signal that local data may have changed.
- **User-initiated.** Wire it to a “Sync now” / pull-to-refresh control in your own UI.

### De-duplication and Debounce

You can call [`syncOfflineIRCodes(force:onProgress:)`](../reference/irvision.md#syncofflineircodesforceonprogress) freely from any of the triggers above without coordinating between them:

- **In-flight de-duplication.** If a sync is already running, additional calls join the same operation and receive its result instead of starting a second sync. Only the initiating call’s `onProgress` receives granular progress updates; joiners get the final [`IROfflineSyncStats`](../reference/irofflinesyncstats.md).
- **Debounce.** A non-forced call made shortly after a successful sync short-circuits and returns the previous stats, avoiding redundant network traffic from back-to-back foreground triggers. Pass `force: true` to bypass the debounce — typical for silent push, where your server has just signaled a change.

Sync failures are non-fatal: the previously-synced catalog continues to serve recognition.

## Observe Sync State

For a “syncing…” indicator or a “last updated” label that lives outside the call site, observe the published sync state on [`IRVision`](../reference/irvision.md):

- [`isSyncingOfflineCatalog`](../reference/irvision.md#issyncingofflinecatalog) — `true` while a sync is running.
- [`lastOfflineSyncDate`](../reference/irvision.md#lastofflinesyncdate) — timestamp of the last successful sync, or `nil`.
- [`lastOfflineSyncStats`](../reference/irvision.md#lastofflinesyncstats) — the [`IROfflineSyncStats`](../reference/irofflinesyncstats.md) from the last successful sync, or `nil`.

Changes are posted via `Notification.Name.irkitOfflineSyncStateChanged`:

```swift
NotificationCenter.default.addObserver(
    forName: .irkitOfflineSyncStateChanged, object: nil, queue: .main
) { _ in
    spinner.isHidden = !IRVision.isSyncingOfflineCatalog
    if let date = IRVision.lastOfflineSyncDate {
        lastUpdatedLabel.text = "Updated \(date.formatted())"
    }
}
```

## How Online and Offline Interact

When the engine is active, the live and still-image paths can use local recognition when the online service cannot provide a result. Both paths return the same [`ImageModel`](../reference/imagemodel.md) type, so the host does not need separate result models.

## Receive Matches in Your Host UI

Offline matches are delivered through the same surface as online matches, so no branching is required:

```swift
IRCameraView()
    .onIRCodeRecognized { imageModel in
        handle(imageModel)   // fully-populated, online or offline
        return true          // return true to suppress IRKit's built-in result UI
    }
```

The still-image API [`identifyImage(_:)`](../reference/irvision.md#identifyimage_) likewise returns the same [`ImageModel`](../reference/imagemodel.md) shape regardless of which path produced it.

### Recognize On-device Only

For host-driven flows where you explicitly want an on-device answer, use [`recognizeOffline(_:)`](../reference/irvision.md#recognizeoffline_) (still image) or [`recognizeOffline(pixelBuffer:)`](../reference/irvision.md#recognizeofflinepixelbuffer) (camera frame):

```swift
if let match = await IRVision.shared.recognizeOffline(image) {
    handle(match)   // fully-populated ImageModel from the local catalog
}
```

Both return `nil` when offline recognition is not active (no engine registered, disabled, or preflight not passed) or when no match is found. Prefer [`identifyImage(_:)`](../reference/irvision.md#identifyimage_) for the standard experience that favors the richer online result while reachable.

## Clear the Local Catalog

To discard cached recognition data (sign-out, account switch), call [`clearOfflineCache()`](../reference/irvision.md#clearofflinecache). The next [`syncOfflineIRCodes(force:)`](../reference/irvision.md#syncofflineircodesforce) rebuilds it. No-ops when no engine is registered.

```swift
await IRVision.shared.clearOfflineCache()
```

### Multi-lens Hosts

[`configure(with:)`](../reference/irvision.md#configurewith) namespaces offline state by subscription key. Switching keys activates that lens’s own toggle and registered engine (defaulting to offline off until enabled). Reconfiguring with the **same** key keeps that lens’s offline toggle — the documented “survives configure” behavior for single-lens hosts.

## Operational Considerations

- **Optional dependency.** A host without an engine runs online-only.
- **Resource use.** The engine controls its own local resources and may require a brief warm-up before the first match.
- **First-run sync.** A fresh install needs at least one successful sync before offline matches can be produced. Plan your sync triggers accordingly.
- **Platform.** Offline recognition is iOS-only; other targets continue to use the online recognition service.
