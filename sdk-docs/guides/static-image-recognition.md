---
title: "Recognizing Still Images"
description: "Use identifyImage(_:) when your app already has a UIImage and you want IRKit to return metadata without presenting the built-in camera UI"
order: 6
---

Use [`identifyImage(_:)`](../reference/irvision.md#identifyimage_) when your app already has a `UIImage` and you want IRKit to return metadata without presenting the built-in camera UI.

## When to Use This Flow

This integration is ideal when your app:

- already has its own camera experience
- uses `PhotosPicker` or `PHPickerViewController`
- analyzes paused video frames
- wants to show fully custom result UI

The demo app uses this pattern for a tap-to-scan experience driven by a paused video frame.

## Step 1: Configure IRKit

Call [`configure(with:)`](../reference/irvision.md#configurewith) before making any recognition request.

```swift
import IRKit

var configuration = IRVisionConfiguration(
    subscriptionKey: "your-subscription-key"
)

IRVision.configure(with: configuration)
```

## Step 2: Obtain a UIImage

IRKit accepts a `UIImage`. How you obtain it is up to your host app:

- capture a photo with your own camera screen
- read an image from the photo library
- render a paused `AVPlayer` frame
- receive an uploaded image from another workflow

## Step 3: Run Recognition

Call [`identifyImage(_:)`](../reference/irvision.md#identifyimage_) from an async context.

```swift
import UIKit
import IRKit

@MainActor
final class RecognitionViewModel: ObservableObject {
    @Published private(set) var isSearching = false
    @Published private(set) var matchedImage: ImageModel?

    func recognize(_ image: UIImage) {
        isSearching = true

        Task {
            let result = await IRVision.shared.identifyImage(image)
            await MainActor.run {
                self.isSearching = false
                self.matchedImage = result
            }
        }
    }
}
```

The method returns:

- an [`ImageModel`](../reference/imagemodel.md) when IRKit finds a match
- `nil` when there is no match

## Step 4: Read the Result

`ImageModel` exposes partner-facing fields directly:

```swift
if let imageModel = matchedImage {
    print(imageModel.imageID)
    print(imageModel.previewTitle)
    print(imageModel.imageDescription ?? "")
    print(imageModel.tags)
    print(imageModel.products.count)
}
```

Commonly used properties:

- `previewTitle` and `previewSubTitle` for compact UI
- `title`, `subtitle`, and `imageDescription` for detail screens
- `displayUrl` for thumbnails
- `tags` for filtering, chips, or search
- `products` for commerce buttons or lists

## Step 5: Present Your Own UI

Because this flow does not use [`IRCameraView`](../reference/ircameraview.md), your app fully controls the result presentation.

```swift
import SwiftUI
import IRKit

struct RecognitionResultView: View {
    let imageModel: ImageModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(imageModel.previewTitle)
                .font(.title2.bold())

            if !imageModel.tags.isEmpty {
                Text(imageModel.tags.joined(separator: ", "))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            ForEach(imageModel.products) { product in
                Link(product.title, destination: URL(string: product.linkToFollow)!)
            }
        }
        .padding()
    }
}
```

## Optional Runtime Configuration

Before recognition, you can also tailor runtime behavior with [`IRVision`](../reference/irvision.md):

- `setDeviceID(_:)`
- `identifyUser(_:)`
- `setHapticFeedbackEnabled(_:)`
- `setGazePoint(_:)`

These settings are optional and depend on your analytics and product requirements.
