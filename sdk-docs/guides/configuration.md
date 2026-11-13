---
title: "Configuring IRKit"
description: "Use IRVisionConfiguration to initialize IRKit with your subscription key, environment, and partner-specific analytics values"
order: 1
---

Use [`IRVisionConfiguration`](../reference/irvisionconfiguration.md) to initialize IRKit with your subscription key, environment, and partner-specific analytics values.

## Basic Configuration

```swift
import IRKit

var configuration = IRVisionConfiguration(
    subscriptionKey: "your-subscription-key"
)

IRVision.configure(with: configuration)
```

## Configuration Fields

### `subscriptionKey`

Required. This enables IRKit for your app and should be provided by IRCODE.

### `enableDebugLogging`

Optional. Enables additional SDK logging that is useful during integration and troubleshooting.

### `baseURL`

Optional. Override the service base URL when you need to point IRKit to a custom environment.

### `deviceID`

Optional. Sets a device identifier at configuration time. You can also update it later through [`setDeviceID(_:)`](../reference/irvision.md#setdeviceid_).

### `Environment`

Select the service environment:

- [`IREnvironment.development`](../reference/irenvironment.md#irenvironmentdevelopment)
- [`IREnvironment.staging`](../reference/irenvironment.md#irenvironmentstaging)
- [`IREnvironment.production`](../reference/irenvironment.md#irenvironmentproduction)

### `analyticsCompany`

Partner or company identifier associated with IRKit analytics events.

### `appSource`

App-specific source string associated with analytics events.

### `enableDebugOptions`

A mutable property that controls whether the built-in debug options entry point is visible in [`IRCameraView`](../reference/ircameraview.md).

> **Note:** Segmentation runs with **Core ML** and requires iOS 17+. On older OS versions segmentation is inactive and the live pipeline falls back to its non-segmented path.

### `segmentationModelName`

Optional. Selects a bundled segmentation model for the session, overriding the automatic choice. Leave `nil` (the default) to let the lens configuration choose.

Most hosts should leave this unset. Enabling [`gazeBoundingMode(_:)`](../reference/ircameraview.md#gazeboundingmode_) selects the model required by that experience, so set `segmentationModelName` only when you need to choose a model independently.

```swift
var configuration = IRVisionConfiguration(
    subscriptionKey: "your-subscription-key",
    analyticsCompany: "your-company"
)
configuration.segmentationModelName = "your-model-name"

IRVision.configure(with: configuration)
```

### Offline Recognition (Optional)

Offline recognition is an optional, on-device capability provided by a host-integrated engine and enabled at runtime. It is **off by default** and is not configured through [`IRVisionConfiguration`](../reference/irvisionconfiguration.md). To use it, register the engine with [`registerOfflineRecognitionEngine(_:)`](../reference/irvision.md#registerofflinerecognitionengine_) and enable it with [`setOfflineEngineEnabled(_:)`](../reference/irvision.md#setofflineengineenabled_). A host that does not integrate an engine runs online-only. See [Offline recognition](offline-recognition.md) for the integration guide.

## Runtime Adjustments

After configuration, [`IRVision`](../reference/irvision.md) exposes optional runtime hooks:

- `setDeviceID(_:)`
- `identifyUser(_:)`
- `setHapticFeedbackEnabled(_:)`
- `setGazePoint(_:)`
- `setGazeBoundingMode(_:)` — toggles Gaze Bounding Mode while a lens is open (see [Building a live camera experience with `IRCameraView`](camera-view.md))
- `setFrameQualityChangedHandler(_:)`

Example:

```swift
IRVision.shared.setDeviceID("device-123")
IRVision.shared.identifyUser("user-456")
IRVision.shared.setHapticFeedbackEnabled(true)
```

## Recommended Startup Pattern

Configure IRKit once during app startup, before presenting [`IRCameraView`](../reference/ircameraview.md) or calling [`identifyImage(_:)`](../reference/irvision.md#identifyimage_).

If your app switches between environments or subscription keys for testing, call [`configure(with:)`](../reference/irvision.md#configurewith) with a new [`IRVisionConfiguration`](../reference/irvisionconfiguration.md) before starting the next recognition flow. Mutable settings are kept separately for each subscription key, so switching keys restores the corresponding settings.
