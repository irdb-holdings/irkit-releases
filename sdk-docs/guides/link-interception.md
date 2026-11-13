---
title: "Intercepting Result Links"
description: "Use onResultLinkTapped(_:) to take control of navigation when a user taps a link inside IRKit’s built-in result UI"
order: 4
---

Use [`onResultLinkTapped(_:)`](../reference/ircameraview.md#onresultlinktapped_) to take control of navigation when a user taps a link inside IRKit’s built-in result UI.

## Overview

IRKit can surface several tap targets from a recognized result:

- generic links
- scan-to-site actions
- product buttons

When a tap occurs, IRKit creates an [`IRResultLinkTapInfo`](../reference/irresultlinktapinfo.md) value and passes it to your handler.

IRKit analytics are still recorded before your handler runs.

## Return Value Semantics

Your handler returns a `Bool`:

- return `true` when your app handled the action and IRKit should stop
- return `false` when IRKit should continue with its default navigation

```swift
IRCameraView()
    .onResultLinkTapped { info in
        print(info.urlString)
        return true
    }
```

## Inspecting the Tap

[`IRResultLinkTapInfo`](../reference/irresultlinktapinfo.md) exposes the information host apps usually need:

- `kind`: whether the action came from a general link, scan-to-site action, or product
- `source`: where in the UI the tap happened
- `url` and `urlString`: the destination
- `title` and `icon`: presentation metadata when available
- `imageID`, `imagePreviewTitle`, and `imagePreviewSubtitle`: context about the recognized result

## Example: Present a Confirmation Dialog

The demo app intercepts result taps, stores the `IRResultLinkTapInfo`, and then decides whether to open the URL itself.

```swift
import SwiftUI
import IRKit

struct CameraScreen: View {
    @Environment(\.openURL) private var openURL

    @State private var pendingLinkTap: IRResultLinkTapInfo?
    @State private var showLinkDialog = false

    var body: some View {
        IRCameraView()
            .onResultLinkTapped { info in
                pendingLinkTap = info
                showLinkDialog = true
                return true
            }
            .confirmationDialog(
                "Link tapped",
                isPresented: $showLinkDialog,
                titleVisibility: .visible
            ) {
                if let url = pendingLinkTap?.url {
                    Button("Open manually") {
                        openURL(url)
                    }
                }

                Button("Cancel", role: .cancel) {}
            } message: {
                Text(pendingLinkTap?.urlString ?? "")
            }
    }
}
```

## Common Patterns

Typical host-app implementations include:

- opening links inside an in-app browser
- routing products into a native commerce experience
- showing a confirmation alert before leaving the app
- recording additional partner analytics
