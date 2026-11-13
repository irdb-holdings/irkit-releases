---
title: "ProductLinkModel"
description: "A purchasable product associated with a recognized IRCODE"
---

A purchasable product associated with a recognized IRCODE.

```swift
struct ProductLinkModel
```

## Instance Properties

### id

Stable identifier for the product entry.

```swift
var id: String
```

### imageUrl

Optional product image URL string for thumbnails and cards.

```swift
var imageUrl: String?
```

### linkToFollow

Destination URL string the host app can open when the product is tapped.

```swift
var linkToFollow: String
```

### title

User-facing product title displayed in SDK or host UI.

```swift
var title: String
```
