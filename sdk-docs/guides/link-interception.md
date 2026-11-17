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
        print(info.url)
        return true
    }
```

## Inspecting the Tap

[`IRResultLinkTapInfo`](../reference/irresultlinktapinfo.md) exposes the information host apps usually need:

- `kind`: whether the action came from a general link, scan-to-site action, or product
- `source`: where in the UI the tap happened
- `url`: the destination to open, with the scan's attribution already added
- `urlString`: the destination as the IRCODE's owner entered it, before attribution
- `clickID`: the click ID IRKit sent on this tap's statistics event
- `title` and `icon`: presentation metadata when available
- `imageID`, `imagePreviewTitle`, and `imagePreviewSubtitle`: context about the recognized result

## Open `url`, Not `urlString`

When your app opens the destination itself, open `url`. IRKit has added the scan's attribution to it: the pairing parameters on an ircode.tv microsite, and `irclid` and `irsid` on any other site. A purchase or sign-up on that site can then be joined back to the scan. `urlString` is the link as it was entered, without that attribution, so opening it loses the conversion.

Use `urlString` only to show or compare the original link, for example to recognize your own domain.

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
                Text(pendingLinkTap?.url.absoluteString ?? "")
            }
    }
}
```

## Common Patterns

Typical host-app implementations include:

- opening `url` inside an in-app browser
- routing products into a native commerce experience
- showing a confirmation alert before leaving the app
- recording additional partner analytics
