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

Resolved destination URL, if the string was a valid URL.

```swift
let url: URL
```

### urlString

Original URL string supplied with the result.

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
