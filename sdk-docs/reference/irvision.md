---
title: "IRVision"
description: "Provides image recognition for still images and live camera frames"
---

Provides image recognition for still images and live camera frames.

```swift
class IRVision
```

## Overview

Configure IRKit once during app startup, then use the shared instance or [`IRCameraView`](ircameraview.md) to recognize IRCODE-enabled images.

Usage example:

```swift
// Configure the IRKit SDK
let config = IRVisionConfiguration(subscriptionKey: "your-key", analyticsCompany: "your-company")
IRVision.configure(with: config)

// Use the shared instance to perform image recognition
let result = await IRVision.shared.identifyImage(myImage)
```

## Instance Properties

### isOfflineRecognitionAvailable

Whether this device has a locally cached catalog available for on-device recognition.

```swift
var isOfflineRecognitionAvailable: Bool { get async }
```

#### Discussion

Returns `true` only when an offline engine is registered, enabled, passed preflight, and reports a non-empty local catalog. Use it to drive UI affordances such as a “ready for offline use” indicator.

See [Offline recognition](../guides/offline-recognition.md).

## Instance Methods

### clearOfflineCache()

Clears the local offline catalog from this device.

```swift
func clearOfflineCache() async
```

#### Discussion

Use this when the user signs out, switches accounts, or otherwise needs to discard cached recognition data. The next call to [`syncOfflineIRCodes(force:)`](irvision.md#syncofflineircodesforce) will rebuild the catalog from scratch. Also resets the observable sync state ([`lastOfflineSyncDate`](irvision.md#lastofflinesyncdate) / [`lastOfflineSyncStats`](irvision.md#lastofflinesyncstats)). No-ops on the engine when none is registered.

See [Offline recognition](../guides/offline-recognition.md).

### fetchIRCode(imageID:)

Fetches a fully populated `ImageModel` for a known IRCODE identifier.

```swift
func fetchIRCode(imageID: String) async -> ImageModel?
```

#### Discussion

Used by Visual Intelligence deep links and other entry points that already know the `imageID` and need metadata (title, thumbnail, microsite links).

### identifyImage(_:)

Performs a single-shot recognition request using a `UIImage`.

```swift
func identifyImage(_ image: UIImage) async -> ImageModel?
```

**Parameters**

- `image`: The image to analyze.

#### Return Value

The recognized image metadata, or `nil` when no match is found.

#### Discussion

Returns a populated `ImageModel` when a matching IRCODE is found; otherwise returns `nil`.

### identifyImage(schedule:framing:firstFrame:captureFrame:)

Performs recognition as a burst of independently captured frames.

```swift
func identifyImage(schedule: IRBurstSchedule = .tapToScan, framing: IRQueryFraming = .fullFrame, firstFrame: UIImage? = nil, captureFrame: @escaping IRFrameProvider) async -> ImageModel?
```

**Parameters**

- `schedule`: When each frame is captured, and the deadline after which the scan is called a miss. Defaults to [`tapToScan`](irburstschedule.md#taptoscan).
- `framing`: How the query image is built from each frame. Defaults to [`IRQueryFraming.fullFrame`](irqueryframing.md#irqueryframingfullframe), since a burst is worth running on content that is already composed — a player’s video — rather than on a camera scene.
- `firstFrame`: A frame you have already captured, used for the first attempt instead of calling `captureFrame` again. Pass the frame you are showing the user, so the first query matches what is on screen.
- `captureFrame`: Supplies a fresh frame for every other attempt. Called on the main actor; return `nil` to skip an attempt.

#### Return Value

The recognized image metadata, or `nil` when no match is found.

#### Discussion

One call starts several attempts staggered over time, and the earliest one that finds something wins. `captureFrame` is called once per attempt, so each samples a different moment of a moving scene. Attempts stop at the first hit, so a quick match costs nothing extra.

Use this rather than [`identifyImage(_:)`](irvision.md#identifyimage_) whenever the source keeps moving — a playing video, a live preview — and the single-shot form when there is only ever one frame to scan, such as a photo picked from the library.

### identifyUser(_:)

Identifies the current user for analytics purposes. Pass a unique string (e.g. account ID) to override the default auto-generated installation identifier. Pass nil to revert to the default.

```swift
func identifyUser(_ userID: String?)
```

### recognizeOffline(_:)

Recognizes a still image using the on-device data only.

```swift
func recognizeOffline(_ image: UIImage) async -> ImageModel?
```

#### Discussion

Use this for host-driven flows where you explicitly want an offline answer (for example a “search offline” affordance). For the standard experience that can use online recognition when available, use [`identifyImage(_:)`](irvision.md#identifyimage_) instead.

Returns `nil` when offline recognition is not active (no engine registered, disabled, or preflight not passed) or when no match is found. See [Offline recognition](../guides/offline-recognition.md).

### recognizeOffline(pixelBuffer:)

Recognizes a camera frame using the on-device data only.

```swift
func recognizeOffline(pixelBuffer: CVPixelBuffer) async -> ImageModel?
```

#### Discussion

Returns `nil` when offline recognition is not active or when no match is found. See [Offline recognition](../guides/offline-recognition.md).

### setDeviceID(_:)

Sets or clears the device identifier associated with analytics events.

```swift
func setDeviceID(_ deviceID: String?)
```

### setFrameQualityChangedHandler(_:)

Registers a callback for live frame quality updates. Passing nil clears the callback.

```swift
func setFrameQualityChangedHandler(_ handler: ((IRFrameQuality) -> Void)?)
```

### setGazePoint(_:)

Sets the gaze point used by gaze-based segmentation models. Coordinates are normalized in [0, 1], matching camera focus coordinates.

```swift
func setGazePoint(_ point: CGPoint)
```

### setGazePoint(x:y:)

Convenience overload for setting gaze point.

```swift
func setGazePoint(x: CGFloat, y: CGFloat)
```

### setHapticFeedbackEnabled(_:)

Enables haptic feedback in the UI when using IRKit-provided result cards.

```swift
func setHapticFeedbackEnabled(_ hapticFeedbackEnabled: Bool)
```

### syncOfflineIRCodes(force:)

Refreshes the local offline recognition data.

```swift
@discardableResult func syncOfflineIRCodes(force: Bool = false) async throws -> IROfflineSyncStats
```

**Parameters**

- `force`: When `true`, bypasses any debounce the engine applies.

#### Return Value

[`IROfflineSyncStats`](irofflinesyncstats.md) describing the outcome of the sync.

#### Discussion

Adds, updates, and deletions are applied incrementally — only changes since the last successful sync are downloaded — so repeated calls are inexpensive once the catalog is established. This is the single entry point for offline catalog maintenance; the SDK does not auto-sync.

**Recommended integration points**

- **App foreground.** Call from `applicationDidBecomeActive(_:)` to refresh whenever the user returns to the app.
- **Silent push.** Call with `force: true` from your remote notification handler when your app receives a signal that local data may have changed.
- **Just-in-time.** Any moment where you have evidence the catalog should refresh — pull-to-refresh, a campaign list screen, after sign-in — is also a valid trigger.

Concurrent calls are deduplicated: if a sync is already in flight, later callers receive the same in-flight result. A short debounce window suppresses redundant network traffic from back-to-back foreground triggers; pass `force: true` to bypass it when your app has just received a change signal.

Sync failures do not affect the existing local data. Recognition continues to use whatever was last successfully synced.

See [Offline recognition](../guides/offline-recognition.md).

> **Throws:** [`IROfflineEngineError.notIntegrated`](irofflineengineerror.md#irofflineengineerrornotintegrated) when no offline engine is registered, or any error the engine surfaces.

### syncOfflineIRCodes(force:onProgress:)

Refreshes the local offline catalog, reporting incremental progress.

```swift
@discardableResult func syncOfflineIRCodes(force: Bool = false, onProgress: (@Sendable (IROfflineSyncProgress) -> Void)?) async throws -> IROfflineSyncStats
```

**Parameters**

- `force`: When `true`, bypasses any debounce the engine applies.
- `onProgress`: Optional progress handler invoked on the main thread.

#### Return Value

[`IROfflineSyncStats`](irofflinesyncstats.md) describing the outcome of the sync.

#### Discussion

Progress callbacks are delivered on the main thread so they can drive a download-progress UI directly.

> **Throws:** [`IROfflineEngineError.notIntegrated`](irofflineengineerror.md#irofflineengineerrornotintegrated) when no offline engine is registered, or any error the engine surfaces.

## Type Properties

### isOfflineEngineAvailable

Whether a host has registered an offline recognition engine for the active lens.

```swift
static var isOfflineEngineAvailable: Bool { get }
```

### isSyncingOfflineCatalog

Whether an offline catalog sync is currently running for the active lens.

```swift
static var isSyncingOfflineCatalog: Bool { get }
```

#### Discussion

Updated by [`syncOfflineIRCodes(force:onProgress:)`](irvision.md#syncofflineircodesforceonprogress) and published via `Notification.Name.irkitOfflineSyncStateChanged` so a host can drive a “syncing…” indicator without holding onto the sync call site.

### lastOfflineSyncDate

The timestamp of the last successful offline catalog sync for the active lens, or `nil` if none has completed. Cleared by [`clearOfflineCache()`](irvision.md#clearofflinecache).

```swift
static var lastOfflineSyncDate: Date? { get }
```

### lastOfflineSyncStats

The [`IROfflineSyncStats`](irofflinesyncstats.md) returned by the last successful offline catalog sync for the active lens, or `nil` if none has completed. Cleared by [`clearOfflineCache()`](irvision.md#clearofflinecache).

```swift
static var lastOfflineSyncStats: IROfflineSyncStats? { get }
```

### offlineEngine

The host-registered offline recognition engine for the **active** lens, if any.

```swift
static var offlineEngine: IROfflineRecognitionEngine? { get }
```

#### Discussion

When `nil`, offline recognition is unavailable and the SDK runs online-only.

### offlineEngineEnabled

The persisted offline-recognition toggle for the **active** lens. Defaults to `false`. Survives [`configure(with:)`](irvision.md#configurewith) when reconfiguring the **same** subscription key; switching to a different key activates that lens’s own toggle (defaulting to `false` until enabled). Assigning schedules an asynchronous preflight that updates [`offlineEngineStatus`](irvision.md#offlineenginestatus); prefer [`setOfflineEngineEnabled(_:)`](irvision.md#setofflineengineenabled_) when you need the resulting status.

```swift
static var offlineEngineEnabled: Bool { get set }
```

### offlineEngineStatus

The current runtime status of offline recognition for the active lens.

```swift
static var offlineEngineStatus: IROfflineEngineStatus { get }
```

#### Discussion

Updated by [`setOfflineEngineEnabled(_:)`](irvision.md#setofflineengineenabled_) / [`registerOfflineRecognitionEngine(_:)`](irvision.md#registerofflinerecognitionengine_) and published via `Notification.Name.irkitOfflineEngineStatusChanged`.

### shared

The shared singleton instance of IRVision. Use this property to access image recognition functionality throughout your app.

```swift
static var shared: IRVision { get }
```

## Type Methods

### configure(with:)

Configures the shared instance with custom configuration settings. Call this method early in your app’s lifecycle to set up IRKit.

```swift
static func configure(with configuration: IRVisionConfiguration)
```

**Parameters**

- `configuration`: The configuration object containing settings like subscription key.

#### Discussion

Offline recognition is an optional, host-injected capability that is independent of this call. To use it, register an engine with [`registerOfflineRecognitionEngine(_:)`](irvision.md#registerofflinerecognitionengine_), enable it via [`setOfflineEngineEnabled(_:)`](irvision.md#setofflineengineenabled_), and hydrate the catalog with [`syncOfflineIRCodes(force:)`](irvision.md#syncofflineircodesforce). See [Offline recognition](../guides/offline-recognition.md).

When the subscription key changes, the SDK snapshots the outgoing lens’s mutable settings (including debug-sheet edits and the offline toggle) and restores the incoming lens’s namespace so configuration never leaks between lenses. Reconfiguring with the **same** key keeps that lens’s state (including a previously enabled offline toggle).

Changing the environment causes subsequent recognition requests to use the newly selected environment.

### registerOfflineRecognitionEngine(_:)

Registers a host-provided offline recognition engine for the **active** lens. This is the only signal of optional-package presence for that lens; calling it makes [`isOfflineEngineAvailable`](irvision.md#isofflineengineavailable) `true` while the lens is active.

```swift
static func registerOfflineRecognitionEngine(_ engine: IROfflineRecognitionEngine)
```

### setGazeBoundingMode(_:)

Enables or disables Gaze Bounding Mode at runtime.

```swift
static func setGazeBoundingMode(_ enabled: Bool)
```

#### Discussion

When enabled, the live gaze bounding box overlay is shown, the guiding rectangle is hidden, and the capture button submits the gaze crop instead of a full-screen photo. When disabled: the session model override is cleared so the lens default model re-resolves.

Hosts normally set the initial value via the [`gazeBoundingMode(_:)`](ircameraview.md#gazeboundingmode_) modifier; this method is for flipping it live (e.g. a settings toggle).

### setOfflineEngineEnabled(_:)

Enables or disables offline recognition for the active lens. When enabling, this runs a one-time preflight against the registered engine and returns the resulting [`IROfflineEngineStatus`](irofflineenginestatus.md) so callers can react (for example a settings toggle reverting itself when the engine is unavailable).

```swift
@discardableResult static func setOfflineEngineEnabled(_ enabled: Bool) async -> IROfflineEngineStatus
```
