---
title: "Hosting IRKit in a UIKit App"
description: "Use a UIHostingController when your app is UIKit-based but you still want to present IRCameraView"
order: 3
---

Use a `UIHostingController` when your app is UIKit-based but you still want to present [`IRCameraView`](../reference/ircameraview.md).

## Overview

IRKit does not expose a standalone `IRCameraViewController`. The recommended UIKit integration is to:

1. configure IRKit during app startup
2. create an [`IRCameraView`](../reference/ircameraview.md)
3. embed it in a `UIHostingController`
4. present or push that hosting controller from UIKit

The demo app follows this pattern.

## Example

```swift
import UIKit
import SwiftUI
import IRKit

final class CameraContainerViewController: UIViewController {
    private var hostingController: UIHostingController<AnyView>?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        title = "IRKit Lens"

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapClose)
        )

        let cameraView = IRCameraView()
            .backButtonStyle(.none)
            .showGuidingRectangle(true)
            .onIRCodeRecognized { imageModel in
                print(imageModel.imageID)
            }

        let hostingController = UIHostingController(rootView: AnyView(cameraView))
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        hostingController.didMove(toParent: self)
        self.hostingController = hostingController
    }

    @objc private func didTapClose() {
        dismiss(animated: true)
    }
}
```

## Navigation Tips

- Use [`backButtonStyle(_:)`](../reference/ircameraview.md#backbuttonstyle_) with `.none` when UIKit should own dismissal.
- Add a `UINavigationItem` close or back button if you present the camera inside a navigation controller.
- Use [`onBackButtonTapped(_:)`](../reference/ircameraview.md#onbackbuttontapped_) if you want the IRKit back button to call into UIKit-owned navigation.

## Recognition Handling

The most common UIKit integration is to pass recognized results into your own coordinator or view controller:

```swift
let cameraView = IRCameraView()
    .onIRCodeRecognized { imageModel in
        print(imageModel.previewTitle)
        print(imageModel.tags)
        return false
    }
```

For link interception, also consider [`onResultLinkTapped(_:)`](../reference/ircameraview.md#onresultlinktapped_).
