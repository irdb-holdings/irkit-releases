---
title: "IRResultLinkTapInfo"
description: "Metadata about a link/product action initiated from IRKit’s result card UI"
---

Metadata about a link/product action initiated from IRKit’s result card UI.

```swift
struct IRResultLinkTapInfo
```

## Overview

The SDK records the interaction before invoking the host-provided handler.

- If the handler returns `true`, the SDK does not perform its default navigation.
- If the handler returns `false`, the SDK continues with its default navigation.

## Instance Properties

### clickID

The click ID IRKit sent on this tap’s statistics event. `url` carries it as `irclid` unless the destination is an ircode.tv microsite or not a web link.

```swift
let clickID: String
```

### icon

Optional icon name/string associated with the link (when applicable).

```swift
let icon: String?
```

### imageID

The recognized image identifier, for correlation/debugging.

```swift
let imageID: String
```

### imagePreviewSubtitle

```swift
let imagePreviewSubtitle: String?
```

### imagePreviewTitle

User-facing preview title/subtitle for the recognized image, when available.

```swift
let imagePreviewTitle: String?
```

### kind

The category of tap target the user activated.

```swift
let kind: Kind
```

### openInNewWindow

Whether the link is marked to open in a new window, when applicable.

```swift
let openInNewWindow: Bool
```

### privateDetails

Whether the link is marked as private details, when applicable.

```swift
let privateDetails: Bool
```

### source

The location in the result UI where the interaction originated.

```swift
let source: Source
```

### title

Optional user-visible title for the link/product.

```swift
let title: String?
```

### url

The URL to open. IRKit has already added the scan’s attribution to it: the pairing params on an ircode.tv microsite, `irclid` and `irsid` on any other site. Open this one so a later conversion joins back to the scan.

```swift
let url: URL
```

### urlString

Original URL string supplied with the result, before any attribution was added.

```swift
let urlString: String
```

## Enumerations

### IRResultLinkTapInfo.Kind

The high-level type of destination the user tapped.

```swift
enum Kind
```

### IRResultLinkTapInfo.Source

Where in the UI the tap originated from.

```swift
enum Source
```
