---
title: "iOS SDK"
description: "Put IRCODE scanning in your iOS app with IRKit"
---

Recognize IRCODE-enabled images in your app with a live camera experience or a still-image recognition flow.

## Overview

IRKit exposes two primary partner integration paths:

- Use [`IRCameraView`](reference/ircameraview.md) when you want IRKit to provide the camera UI and result-card experience.
- Use [`identifyImage(_:)`](reference/irvision.md#identifyimage_) when you already have a `UIImage` from your own camera flow, a photo picker, or a paused video frame.

`IRCameraView` is the fastest way to get a live recognition experience into a SwiftUI app. For UIKit apps, embed that same SwiftUI view inside a `UIHostingController`.

`IRVision` is the lower-level entry point for SDK configuration and still-image recognition. The results you receive are exposed as [`ImageModel`](reference/imagemodel.md) values with partner-facing fields such as titles, descriptions, contact data, `tags`, and [`ProductLinkModel`](reference/productlinkmodel.md) entries.

## Requirements

- iOS 16.3 or later
- iPhone and iPad
- Portrait and landscape

[`IRCameraView`](reference/ircameraview.md) is fully orientation-adaptive and keeps the query images sent to the recognition engine upright regardless of device orientation, so recognition works in both portrait and landscape. The orientations your screen presents are ultimately governed by your host app’s orientation settings. IRKit is not currently intended for macOS or visionOS deployments. Gaze Bounding Mode requires iOS 17 or later.

## Configure IRKit

Add the `IRKit` package to your app, import the module, and configure `IRVision`. You can do this as early as possible in app startup or just before the user is about to launch the IRKit-powered experience.

```swift
import SwiftUI
import IRKit

@main
struct YourApp: App {
    init() {
        var configuration = IRVisionConfiguration(
            subscriptionKey: "your-subscription-key"
        )

        IRVision.configure(with: configuration)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

After configuration, you can optionally tailor runtime behavior with methods on [`IRVision`](reference/irvision.md) such as `setDeviceID(_:)`, `identifyUser(_:)`, `setHapticFeedbackEnabled(_:)`, `setGazePoint(_:)`, and `setGazeBoundingMode(_:)`.

## Choose an Integration Path

### Live Camera Experience

Use [`IRCameraView`](reference/ircameraview.md) when you want IRKit to own the recognition UI. The lens runs as a continuous **Live+** scanner. A shutter button for single-shot **Snapshot** capture appears when the active lens enables it; call [`showCaptureButton(_:)`](reference/ircameraview.md#showcapturebutton_) to force it on or off instead:

```swift
import SwiftUI
import IRKit

struct ContentView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        IRCameraView()
            .backButtonStyle(.arrow)
            .showGuidingRectangle(true)
            .showCaptureButton()      // force single-shot capture on
            .onBackButtonTapped {
                dismiss()
            }
            .onIRCodeRecognized { imageModel in
                print("Recognized image: \(imageModel.imageID)")
                print("Tags: \(imageModel.tags)")
                return false
            }
    }
}
```

For a deeper guide — including the Live+ vs Snapshot modes and orientation support — see [Building a live camera experience with `IRCameraView`](guides/camera-view.md).

### Still-image Recognition

Use [`identifyImage(_:)`](reference/irvision.md#identifyimage_) when your app already has a `UIImage`:

```swift
import IRKit
import UIKit

func recognize(image: UIImage) {
    Task {
        let result = await IRVision.shared.identifyImage(image)
        if let result {
            print(result.previewTitle)
            print(result.tags)
        } else {
            print("No match found")
        }
    }
}
```

This is the right approach for photo-pickers, uploaded images, or tap-to-scan flows built with your own UI. See [Recognizing still images](guides/static-image-recognition.md).

### Tap-to-Scan Over a Video Player

Use [`IRTapToScanView`](reference/irtaptoscanview.md) (or the `irTapToScan(...)` modifier) when you want viewers to scan what’s on screen while watching a live or on-demand video, with IRKit presenting an orientation-adaptive result takeover that reuses the live-lens result cards:

```swift
import SwiftUI
import IRKit

struct PlayerScreen: View {
    @State private var isScanning = false
    @StateObject private var player = MyVideoPlayer()

    var body: some View {
        MyVideoView(player: player)
            .irTapToScan(
                isActive: $isScanning,
                captureFrame: { player.currentFrame() }   // -> UIImage?
            )
    }
}
```

See [Adding tap-to-scan over a video player](guides/tap-to-scan.md).

### UIKit Hosting

IRKit does not ship a separate `IRCameraViewController`. For UIKit apps, present a `UIHostingController` whose root view is [`IRCameraView`](reference/ircameraview.md). See [Hosting IRKit in a UIKit app](guides/uikit-integration.md).

## Essentials

- [`IRVision`](reference/irvision.md): Provides image recognition for still images and live camera frames
- [`IRVisionConfiguration`](reference/irvisionconfiguration.md): Configuration values used to initialize the IRKit SDK
- [`IREnvironment`](reference/irenvironment.md): The service environment that IRKit should use
- [Configuring IRKit](guides/configuration.md): Use IRVisionConfiguration to initialize IRKit with your subscription key, environment, and partner-specific analytics values

## Camera Experience

- [`IRCameraView`](reference/ircameraview.md): A SwiftUI view that provides a camera interface for IRKit recognition
- [`IRCameraMode`](reference/ircameramode.md): Defines the different modes available for the camera interface
- [`IRCameraBackButtonStyle`](reference/ircamerabackbuttonstyle.md): Defines the visual style of the back button
- [`IRAutoLaunchScanToSitePolicy`](reference/irautolaunchscantositepolicy.md): Controls whether recognized IRCODEs with an embeddable scan-to-site link skip the collapsed card and expand directly into the in-card web view
- [`IRResultLinkTapInfo`](reference/irresultlinktapinfo.md): Metadata about a link/product action initiated from IRKit’s result card UI
- [`IRFrameQuality`](reference/irframequality.md): A summary of the current camera frame quality for live recognition
- [`IRQualityHint`](reference/irqualityhint.md): Qualitative hints describing why the current camera frame may or may not be suitable for recognition
- [Building a live camera experience with `IRCameraView`](guides/camera-view.md): Use IRCameraView when you want IRKit to provide the camera UI, recognition lifecycle, and default result-card experience
- [Intercepting result links](guides/link-interception.md): Use onResultLinkTapped(_:) to take control of navigation when a user taps a link inside IRKit’s built-in result UI
- [Hosting IRKit in a UIKit app](guides/uikit-integration.md): Use a UIHostingController when your app is UIKit-based but you still want to present IRCameraView

## Tap-to-Scan Over Video

- [`IRTapToScanView`](reference/irtaptoscanview.md): A reusable, orientation-aware “tap to scan” overlay that a host app places above its own video player
- [Adding tap-to-scan over a video player](guides/tap-to-scan.md): Let viewers scan what’s on screen while they keep watching your video, then present IRKit’s result experience as an orientation-adaptive takeover

## Recognition Results

- [`ImageModel`](reference/imagemodel.md): A high-level model representing an IRCODE image and its metadata
- [`ProductLinkModel`](reference/productlinkmodel.md): A purchasable product associated with a recognized IRCODE
- [Understanding result models](guides/result-models.md): When IRKit recognizes an image, the host app works primarily with ImageModel and the associated ProductLinkModel values

## Recognition Guides

- [Recognizing still images](guides/static-image-recognition.md): Use identifyImage(_:) when your app already has a UIImage and you want IRKit to return metadata without presenting the built-in camera UI
- [Offline recognition](guides/offline-recognition.md): Recognize IRCODE-enabled images on-device using an optional, host-integrated recognition engine

## Offline Recognition (Optional Engine)

- [`IROfflineRecognitionEngine`](reference/irofflinerecognitionengine.md): An optional, host-injected on-device recognition engine
- [`IROfflineEngineMatch`](reference/irofflineenginematch.md): A match produced by a host-injected offline recognition engine
- [`IROfflineSyncProgress`](reference/irofflinesyncprogress.md): Progress for an offline data synchronization, surfaced so a host can drive a progress UI
- [`IROfflineSyncStats`](reference/irofflinesyncstats.md): Summary statistics returned when offline data synchronization completes
- [`IROfflineEngineStatus`](reference/irofflineenginestatus.md): Runtime status of the offline recognition engine
- [`IROfflineEngineError`](reference/irofflineengineerror.md): Errors thrown by the offline sync entry points on IRVision

## Sending Analytics Events

- [`AnalyticsService`](reference/analyticsservice.md): Tracks analytics events and identifies the current user
- [`AnalyticsServiceProtocol`](reference/analyticsserviceprotocol.md): The analytics interface: identify the current user and track events
- [`AnalyticsEvent`](reference/analyticsevent.md): An analytics event: a button press, link, scan, status or view
- [`IRAnalyticsHostContext`](reference/iranalyticshostcontext.md): Your app's user, attached to analytics events through setHostContext(_:)
- [`IRAnalyticsImageRepresentable`](reference/iranalyticsimagerepresentable.md): A type that describes an IRCODE in an analytics event's image parameter
- [Sending analytics events](guides/analytics.md): Use AnalyticsService to read or extend the analytics stream associated with IRKit experiences
