---
title: "Building a Live Camera Experience with IRCameraView"
description: "Use IRCameraView when you want IRKit to provide the camera UI, recognition lifecycle, and default result-card experience"
order: 2
---

Use [`IRCameraView`](../reference/ircameraview.md) when you want IRKit to provide the camera UI, recognition lifecycle, and default result-card experience.

## Overview

`IRCameraView` is a SwiftUI view. By default, when IRKit recognizes a result it shows a collapsed preview card that can expand into a detail card.

The callback name is `onIRCodeRecognized`, but the value passed to your app is an [`ImageModel`](../reference/imagemodel.md). That object includes the fields your app is expected to use, including:

- `imageID`
- `previewTitle`
- `previewSubTitle`
- `displayUrl`
- `tags`
- `products`

If you do not override the cards, IRKit uses its built-in result UI.

## Quick Start

```swift
import SwiftUI
import IRKit

struct CameraScreen: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        IRCameraView()
            .backButtonStyle(.arrow)
            .showGuidingRectangle(true)
            .showCaptureButton()          // optional: add a shutter for single-shot capture
            .onBackButtonTapped {
                dismiss()
            }
            .onIRCodeRecognized { imageModel in
                print("Recognized image: \(imageModel.imageID)")
                print("Tags: \(imageModel.tags)")
                return false
            }
            .onCameraError { error in
                print(error.localizedDescription)
            }
    }
}
```

`IRCameraView` recognizes IRCODEs continuously (Live+). The shutter for single-shot Snapshot capture follows the lens configuration by default; use [`showCaptureButton(_:)`](../reference/ircameraview.md#showcapturebutton_) (or [`snapshotCapture(_:)`](../reference/ircameraview.md#snapshotcapture_)) to force it on or off. See **Recognition modes: Live+ and Snapshot** below.

## Recognition Modes: Live+ and Snapshot

`IRCameraView` always runs as a **Live+** lens. A **Snapshot** capture button can appear on top of it when the active lens enables it, or when the host forces it with [`showCaptureButton(_:)`](../reference/ircameraview.md#showcapturebutton_). There is no longer a user-facing mode selector — the two modes are complementary, not mutually exclusive.

### Live+ (Continuous Scanning)

Live+ is the default, always-on experience. The camera continuously analyzes the scene and recognizes IRCODEs hands-free as they come into view, presenting the result card automatically.

Use Live+ when:

- You want zero-tap, ambient recognition (e.g. pointing at a TV, a poster, or signage and having matches appear on their own).
- The target may move or change, and you want the lens to keep finding matches.
- You want the smoothest “just point the camera” experience.

### Snapshot (Capture Button)

Snapshot is a single, deliberate capture triggered by the shutter button. When the user taps it, the lens momentarily pauses the live scan, captures one frame, runs recognition on it (with a shutter animation), and presents the result. Live+ resumes automatically when the result is dismissed or no match is found.

Use Snapshot when:

- The user wants explicit control over _when_ a frame is captured.
- You want a deliberate, single-shot capture of a specific item rather than continuous matching.
- The scene is busy and a precise, user-chosen moment yields a better query than continuous frames.

Enable it with one modifier (forces the button on, ignoring the lens):

```swift
IRCameraView()
    .showCaptureButton()
```

Or defer to / force against the lens configuration explicitly:

```swift
IRCameraView()
    .snapshotCapture(.fromLens)   // default — honor the lens configuration
    // .snapshotCapture(.enabled)
    // .snapshotCapture(.disabled)
```

[`showCaptureButton(_:)`](../reference/ircameraview.md#showcapturebutton_) maps onto `.enabled` / `.disabled` and remains the short form for hosts that want to force the setting. An explicit host call always wins over the lens.

Under `.fromLens`, the debug sheet’s **Snapshot Capture Button** override (see [`enableDebugOptions(_:)`](../reference/ircameraview.md#enabledebugoptions_)) lets QA force the button on or off per lens without editing the lens configuration. It is persisted per lens and outranks the lens configuration, but not an explicit host call.

The shutter is positioned automatically for the device and orientation: centered along the bottom edge in portrait, and centered along the trailing (right) edge in landscape, on both iPhone and iPad.

> **Note:** Snapshot capture is built into [`IRCameraView`](../reference/ircameraview.md). You only need [`identifyImage(_:)`](../reference/irvision.md#identifyimage_) (see [Recognizing still images](static-image-recognition.md)) when you are sourcing images from _outside_ the IRKit camera — a photo picker, your own capture UI, or a paused video frame.

## Gaze Bounding Mode

Use [`gazeBoundingMode(_:)`](../reference/ircameraview.md#gazeboundingmode_) to enable a focused “gaze” experience: IRKit draws an animated bounding box around the item the user is looking at and dims the surrounding preview, so the camera highlights exactly what will be recognized. The box follows the gaze point smoothly and resizes with an elastic animation, and it is clamped to the visible screen.

```swift
IRCameraView()
    .gazeBoundingMode()
    .showCaptureButton()
```

Enabling this mode changes several behaviours together:

- **Selects an appropriate segmentation model** for the session (you do not need to set [`segmentationModelName`](../reference/irvisionconfiguration.md#segmentationmodelname) yourself).
- **Hides the guiding rectangle** — the gaze box replaces it, so [`showGuidingRectangle(_:)`](../reference/ircameraview.md#showguidingrectangle_) has no visible effect while the mode is on.
- **Draws the animated gaze bounding box** overlay over the live preview.
- **Changes the capture button**: instead of capturing a full-screen photo, the shutter submits the _gaze crop_ (the contents of the box) as the recognition query, freezes the preview, and shows an activity indicator inside the box while searching. If no fresh gaze box is available at the moment of capture, it falls back to a normal full-frame snapshot.

Live+ recognition is unaffected — it already queries the gazed region continuously; only the capture button’s query and the on-screen presentation change.

### Toggling at Runtime

The modifier sets the initial value when the lens appears. To flip Gaze Bounding Mode while the lens is already open (for example from a settings switch), call [`setGazeBoundingMode(_:)`](../reference/irvision.md#setgazeboundingmode_):

```swift
// Turn it on/off live; the camera reacts immediately.
IRVision.setGazeBoundingMode(true)
```

When you disable the mode, the forced model override is cleared and the lens’s default segmentation model re-resolves.

## Orientation and Device Support

`IRCameraView` is fully orientation-adaptive on both iPhone and iPad. It supports portrait and landscape, and rotates seamlessly:

- The camera preview and the query images sent to the recognition engine are kept upright regardless of how the device is held, so recognition works correctly in landscape.
- The result card is presented as a bottom sheet in portrait and as a trailing side panel in landscape (mirroring the tap-to-scan takeover), so the camera stays visible alongside the result.

The orientations your screen actually allows are controlled by your host app (its `UISupportedInterfaceOrientations` / scene orientation lock). `IRCameraView` adapts to whatever you permit; a portrait-locked host simply stays in portrait.

## Appearance and Navigation

### Guiding Rectangle

Use [`showGuidingRectangle(_:)`](../reference/ircameraview.md#showguidingrectangle_) to show or hide the on-screen alignment rectangle.

```swift
IRCameraView()
    .showGuidingRectangle(true)
```

### Capture Button

By default the shutter follows the lens configuration ([`IRSnapshotCapturePolicy.fromLens`](../reference/irsnapshotcapturepolicy.md#irsnapshotcapturepolicyfromlens)). Use [`showCaptureButton(_:)`](../reference/ircameraview.md#showcapturebutton_) to force it on or off, or [`snapshotCapture(_:)`](../reference/ircameraview.md#snapshotcapture_) for the full policy. See the **Recognition modes: Live+ and Snapshot** section for when to use it.

```swift
IRCameraView()
    .showCaptureButton()                 // force on
    // .snapshotCapture(.fromLens)       // defer to lens (default)
    // .snapshotCapture(.disabled)       // force off
```

### Gaze Bounding Mode

Use [`gazeBoundingMode(_:)`](../reference/ircameraview.md#gazeboundingmode_) to draw an animated bounding box around the gazed item and change the capture button to submit the gaze crop. See the **Gaze Bounding Mode** section above for the full behaviour.

```swift
IRCameraView()
    .gazeBoundingMode()
```

### Back Button Style

Use [`backButtonStyle(_:)`](../reference/ircameraview.md#backbuttonstyle_) to choose whether the camera shows no back button, an arrow, or a close icon.

```swift
IRCameraView()
    .backButtonStyle(.close)
```

### Back Button Handling

Use [`onBackButtonTapped(_:)`](../reference/ircameraview.md#onbackbuttontapped_) when your host app wants to replace IRKit’s default dismiss behavior.

```swift
IRCameraView()
    .backButtonStyle(.arrow)
    .onBackButtonTapped {
        print("Dismiss the host screen here")
    }
```

### Debug Options

Use [`enableDebugOptions(_:)`](../reference/ircameraview.md#enabledebugoptions_) to expose the SDK debug sheet.

```swift
IRCameraView()
    .enableDebugOptions(true)
```

## Recognition Callbacks

### Recognition Results

Use [`onIRCodeRecognized(_:)`](../reference/ircameraview.md#onircoderecognized_) to receive recognized [`ImageModel`](../reference/imagemodel.md) values.

```swift
IRCameraView()
    .onIRCodeRecognized { imageModel in
        print(imageModel.previewTitle)
        print(imageModel.tags)
        print(imageModel.products.count)
        return true
    }
```

This is the best callback when you want to route to your own detail screen instead of using the built-in cards.

### Camera Errors

Use [`onCameraError(_:)`](../reference/ircameraview.md#oncameraerror_) to surface camera-session or recognition errors in your own UI.

### Frame Quality

Use [`onFrameQualityChanged(_:)`](../reference/ircameraview.md#onframequalitychanged_) to monitor recognition readiness during live scanning.

```swift
IRCameraView()
    .onFrameQualityChanged { quality in
        print("Quality: \(quality.percentage)")
        print("Hints: \(quality.hints)")
    }
```

### Link Interception

Use [`onResultLinkTapped(_:)`](../reference/ircameraview.md#onresultlinktapped_) when you want to intercept links, scan-to-site actions, or product taps that originate from IRKit’s default result cards.

Return `true` to stop IRKit from navigating on its own. Return `false` to let IRKit continue with its default behavior.

```swift
IRCameraView()
    .onResultLinkTapped { info in
        print(info.kind)
        print(info.source)
        print(info.urlString)
        return true
    }
```

For a full guide, see [Intercepting result links](link-interception.md).

### Auto-launching Scan-to-site

Some IRCODEs include an embeddable scan-to-site link. By default IRKit shows the collapsed result card, and a tap on the scan-to-site action expands the in-card web view. [`autoLaunchScanToSite(_:)`](../reference/ircameraview.md#autolaunchscantosite_) lets the host override that behaviour:

- [`IRAutoLaunchScanToSitePolicy.fromLens`](../reference/irautolaunchscantositepolicy.md#irautolaunchscantositepolicyfromlens) (default): defer to the lens configuration’s setting.
- [`IRAutoLaunchScanToSitePolicy.enabled`](../reference/irautolaunchscantositepolicy.md#irautolaunchscantositepolicyenabled): always skip the collapsed card and expand straight into the in-card web view, regardless of the lens flag.
- [`IRAutoLaunchScanToSitePolicy.disabled`](../reference/irautolaunchscantositepolicy.md#irautolaunchscantositepolicydisabled): always show the collapsed card first, regardless of the lens flag.

Applies to Live+ recognition. A Snapshot capture always presents its result directly.

```swift
IRCameraView()
    .autoLaunchScanToSite(.enabled)
```

## Custom Result Cards

### Preview Card

Use [`previewCard(content:)`](../reference/ircameraview.md#previewcardcontent) to replace the collapsed card UI.

```swift
IRCameraView()
    .previewCard { imageModel in
        VStack(alignment: .leading, spacing: 6) {
            Text(imageModel.previewTitle)
                .font(.headline)

            if let firstTag = imageModel.tags.first {
                Text(firstTag.uppercased())
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
```

### Detail Card

Use [`detailCard(content:)`](../reference/ircameraview.md#detailcardcontent) to replace the expanded card UI.

```swift
IRCameraView()
    .detailCard { imageModel in
        VStack(alignment: .leading, spacing: 12) {
            Text(imageModel.title ?? imageModel.previewTitle)
                .font(.title3.bold())

            if let description = imageModel.imageDescription {
                Text(description)
            }

            if !imageModel.tags.isEmpty {
                Text(imageModel.tags.joined(separator: ", "))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
```

### Manual Handling with No Preview Card

If you return `EmptyView()` from the preview card builder, IRKit will not show a card. In that case, handle the recognition event yourself.

```swift
IRCameraView()
    .previewCard { _ in
        EmptyView()
    }
    .onIRCodeRecognized { imageModel in
        print("Present your own screen for \(imageModel.imageID)")
        return true
    }
```

If you provide a preview card but return `EmptyView()` for the detail card, the preview remains visible but no expanded detail view is shown.

## Deprecated: the Mode Selector

Earlier versions of IRKit exposed a Live+/Snapshot segmented **mode selector** in the camera chrome, configured through the modifiers below. Partners found switching modes confusing, so the selector has been removed. The lens is now always Live+, and Snapshot is exposed as the optional capture button described above.

These modifiers are **deprecated** and no longer affect the visible experience. They remain on the API surface only for source compatibility and will be removed in a future release:

- [`showModeSelector(_:)`](../reference/ircameraview.md#showmodeselector_) — replaced by [`showCaptureButton(_:)`](../reference/ircameraview.md#showcapturebutton_)
- [`defaultMode(_:)`](../reference/ircameraview.md#defaultmode_) — the lens is always Live+
- [`liveModeTitle(_:)`](../reference/ircameraview.md#livemodetitle_) — the selector is gone
- [`snapshotModeTitle(_:)`](../reference/ircameraview.md#snapshotmodetitle_) — the selector is gone
- [`onCameraModeChanged(_:)`](../reference/ircameraview.md#oncameramodechanged_) — no longer fires for user-driven mode changes

Migration:

```swift
// Before — selector with a default mode
IRCameraView()
    .showModeSelector(true)
    .defaultMode(.snapshot)

// After — always Live+, with the capture button for single-shot snapshots
IRCameraView()
    .showCaptureButton()
```

## Other Modifiers

- [`gazeBoundingMode(_:)`](../reference/ircameraview.md#gazeboundingmode_)
- [`enableCameraRoll(_:)`](../reference/ircameraview.md#enablecameraroll_)
- [`enableFlashlight(_:)`](../reference/ircameraview.md#enableflashlight_)
