---
title: "IRCameraView"
description: "A SwiftUI view that provides a camera interface for IRKit recognition"
---

A SwiftUI view that provides a camera interface for IRKit recognition. This view can be configured with various options and callbacks to customize its behavior.

```swift
@MainActor struct IRCameraView
```

## Overview

Usage Example:

```swift
IRCameraView()
    .showGuidingRectangle(true)
    .enableFlashlight(true)
    .supportedModes([.snapshot, .live])
    .onIRCodeRecognized { imageModel in
        print("Found image: \(imageModel.title ?? imageModel.previewTitle)")
        return false
    }
```

## Initializers

### init()

Creates an IRKit camera view with the default SDK configuration.

```swift
@MainActor init()
```

## Instance Properties

### body

The body of the view containing the camera interface.

```swift
@MainActor var body: some View { get }
```

## Instance Methods

### autoLaunchScanToSite(_:)

Controls whether a recognized IRCODE with an embeddable scan-to-site link should skip the collapsed card and expand directly into the in-card web view.

```swift
@MainActor func autoLaunchScanToSite(_ policy: IRAutoLaunchScanToSitePolicy) -> IRCameraView
```

#### Discussion

- `.fromLens` (default): defer to the lens configuration.
- `.enabled`: force auto-launch regardless of lens configuration.
- `.disabled`: suppress auto-launch regardless of lens configuration.

Applies only in Live mode; Snapshot mode behavior is unchanged.

### backButtonStyle(_:)

Sets the back button style (arrow or close).

```swift
@MainActor func backButtonStyle(_ style: IRCameraBackButtonStyle) -> IRCameraView
```

**Parameters**

- `style`: The back button style to display.

#### Return Value

A modified IRCameraView.

### defaultMode(_:)

Sets the default camera mode used when the view first appears.

```swift
@MainActor func defaultMode(_ mode: IRCameraMode) -> IRCameraView
```

**Parameters**

- `mode`: The default `IRCameraMode` to use. Defaults to `.live`.

#### Return Value

A modified IRCameraView.

### detailCard(content:)

Supplies a custom expanded (detail) card shown when a recognized result is expanded.

```swift
@MainActor func detailCard<ExpandedContent>(@ViewBuilder content: @escaping (ImageModel) -> ExpandedContent) -> IRCameraView where ExpandedContent : View
```

**Parameters**

- `content`: A builder that returns the expanded view for a given `ImageModel`.

#### Return Value

A modified IRCameraView.

### enableCameraRoll(_:)

Enables access to the camera roll for picking existing images.

```swift
@MainActor func enableCameraRoll(_ enable: Bool = false) -> IRCameraView
```

**Parameters**

- `enable`: Whether to enable camera roll access. Defaults to true.

#### Return Value

A modified IRCameraView.

### enableDebugOptions(_:)

Enables the camera debug options button and sheet.

```swift
@MainActor func enableDebugOptions(_ enable: Bool = true) -> IRCameraView
```

**Parameters**

- `enable`: Whether to show the debug options entry point. Calling this method without an argument enables the entry point.

#### Return Value

A modified IRCameraView.

### enableFlashlight(_:)

Enables flashlight (torch) control for low‑light conditions.

```swift
@MainActor func enableFlashlight(_ enable: Bool = false) -> IRCameraView
```

**Parameters**

- `enable`: Whether to enable flashlight control. Defaults to true.

#### Return Value

A modified IRCameraView.

### gazeBoundingMode(_:)

Enables Gaze Bounding Mode: a live, animated bounding box around the item the user is gazing at, with the surrounding camera preview dimmed. The box moves smoothly as the gaze point changes and resizes with an elastic animation.

```swift
@MainActor func gazeBoundingMode(_ enabled: Bool = true) -> IRCameraView
```

**Parameters**

- `enabled`: Whether to enable Gaze Bounding Mode. Defaults to true.

#### Return Value

A modified IRCameraView.

#### Discussion

Enabling this mode also selects an appropriate segmentation model, hides the guiding rectangle, and changes the capture button so it submits the gaze crop (instead of a full-screen photo) with a freeze + in-box spinner while searching.

### liveModeTitle(_:)

Overrides the display title for the Live+ mode.

```swift
@MainActor func liveModeTitle(_ title: String) -> IRCameraView
```

**Parameters**

- `title`: The title to display in the segmented control.

#### Return Value

A modified IRCameraView.

### onBackButtonTapped(_:)

Registers a callback for back button taps. If provided, it replaces the default dismiss action.

```swift
@MainActor func onBackButtonTapped(_ action: @escaping () -> Void) -> IRCameraView
```

**Parameters**

- `action`: Closure called when the back button is tapped.

#### Return Value

A modified IRCameraView.

### onCameraError(_:)

Registers a callback for camera‑related errors.

```swift
@MainActor func onCameraError(_ action: @escaping (Error) -> Void) -> IRCameraView
```

**Parameters**

- `action`: Closure called with the encountered `Error`.

#### Return Value

A modified IRCameraView.

### onCameraModeChanged(_:)

Registers a callback that fires when the camera mode changes.

```swift
@MainActor func onCameraModeChanged(_ action: @escaping (IRCameraMode) -> Void) -> IRCameraView
```

**Parameters**

- `action`: Closure called with the new `IRCameraMode`.

#### Return Value

A modified IRCameraView.

### onFrameQualityChanged(_:)

Registers a callback invoked when live frame quality changes. The handler receives the current quality percentage and hints.

```swift
@MainActor func onFrameQualityChanged(_ action: @escaping (IRFrameQuality) -> Void) -> IRCameraView
```

**Parameters**

- `action`: Closure called with quality percentage and hints.

#### Return Value

A modified IRCameraView.

### onIRCodeRecognized(_:)

Registers a callback invoked when IRKit recognizes an image.

```swift
@MainActor func onIRCodeRecognized(_ action: @escaping (ImageModel) -> Bool) -> IRCameraView
```

**Parameters**

- `action`: Closure called with the recognized `ImageModel`. Return `true` to suppress IRKit’s default result UI for this match; `false` to let IRKit show its UI as well.

#### Return Value

A modified IRCameraView.

#### Discussion

Mirrors the contract of [`onResultLinkTapped(_:)`](ircameraview.md#onresultlinktapped_). The closure receives the recognized [`ImageModel`](imagemodel.md) and returns a `Bool` that tells the SDK whether to suppress its own result-card UI:

- Return `false` (the default for hosts that just want analytics) to let the SDK present its built-in result card alongside delivering the `ImageModel` to your closure.
- Return `true` to take full control of the post-recognition UX. The SDK will not show a preview card, expanded card, scan-to-site banner, or any other result UI for this match — it’s all yours.

The closure is invoked at most once per `imageID` per active match cycle (re-entering the lens or scanning a different IRCODE resets the dedup).

### onResultLinkTapped(_:)

Registers a callback for result-card link taps (links, scan-to-site, and product buttons).

```swift
@MainActor func onResultLinkTapped(_ handler: @escaping (IRResultLinkTapInfo) -> Bool) -> IRCameraView
```

#### Discussion

- Returns `true` if the host app handled the tap and IRKit should **skip** its default navigation.
- Returns `false` to let IRKit continue with its default navigation (e.g. Safari / deep link).

### previewCard(content:)

Supplies a custom preview (collapsed) card shown when a result is recognized.

```swift
@MainActor func previewCard<CollapsedContent>(@ViewBuilder content: @escaping (ImageModel) -> CollapsedContent) -> IRCameraView where CollapsedContent : View
```

**Parameters**

- `content`: A builder that returns the preview view for a given `ImageModel`.

#### Return Value

A modified IRCameraView.

### showCaptureButton(_:)

Shows a shutter (capture) button inside the Live+ lens.

```swift
@MainActor func showCaptureButton(_ show: Bool = true) -> IRCameraView
```

**Parameters**

- `show`: Whether to display the capture button. Defaults to true.

#### Return Value

A modified IRCameraView.

#### Discussion

The lens always runs as Live+; tapping the capture button performs a single snapshot capture — it pauses the live scan, runs the snapshot recognition pipeline (with the shutter animation), presents the result, and resumes Live+ when the result is dismissed or no match is found.

This replaces the deprecated Live+/Snapshot mode selector.

An explicit call always wins over the lens configuration. Prefer [`snapshotCapture(_:)`](ircameraview.md#snapshotcapture_) when you want to defer to the lens instead.

### showGuidingRectangle(_:)

Displays or hides a guiding rectangle overlay that helps users align the camera with the target IRCODE. The guiding rectangle when enabled appears only in the Live camera mode.

```swift
@MainActor func showGuidingRectangle(_ show: Bool = true) -> IRCameraView
```

**Parameters**

- `show`: Whether to show the guiding rectangle. Defaults to true.

#### Return Value

A modified IRCameraView.

### showModeSelector(_:)

Shows or hides the mode selector control (e.g., Snapshot vs Live).

```swift
@MainActor func showModeSelector(_ show: Bool = true) -> IRCameraView
```

**Parameters**

- `show`: Whether to display the mode selector. Defaults to true.

#### Return Value

A modified IRCameraView.

### snapshotCapture(_:)

Controls whether a shutter (capture) button is shown inside the Live+ lens.

```swift
@MainActor func snapshotCapture(_ policy: IRSnapshotCapturePolicy) -> IRCameraView
```

#### Discussion

- `.fromLens` (default): defer to the lens configuration.
- `.enabled`: always show the capture button, regardless of lens configuration.
- `.disabled`: never show the capture button, regardless of lens configuration.

[`showCaptureButton(_:)`](ircameraview.md#showcapturebutton_) maps onto `.enabled` / `.disabled` and remains the short form for hosts that want to force the setting.

### snapshotModeTitle(_:)

Overrides the display title for the Snapshot mode.

```swift
@MainActor func snapshotModeTitle(_ title: String) -> IRCameraView
```

**Parameters**

- `title`: The title to display in the segmented control.

#### Return Value

A modified IRCameraView.
