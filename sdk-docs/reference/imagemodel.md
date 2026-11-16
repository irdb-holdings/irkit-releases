---
title: "ImageModel"
description: "A high-level model representing an IRCODE image and its metadata"
---

A high-level model representing an IRCODE image and its metadata.

```swift
class ImageModel
```

## Overview

This class encapsulates identifiers, URLs, user-visible text, contact details and other attributes returned by recognition. It is observable to support UI bindings and is safe to pass to SDK view builders.

## Instance Properties

### address

Contact postal address extracted from the image metadata, if provided.

```swift
var address: String? { get }
```

### artistName

The artist/author name associated with the image, if provided.

```swift
var artistName: String? { get }
```

### campaignID

Identifier of the campaign this IRCODE belongs to (when applicable). `0` means no campaign association. Always populated for offline matches surfaced via `onIRCodeRecognized` from `IRCameraView`.

```swift
var campaignID: Int
```

### campaignName

Human-readable campaign name, when available. May be empty for offline matches (the SDK only ships the IDs and tags it actually needs to make matching work without network).

```swift
var campaignName: String
```

### category

A category label classifying the image/content, if provided.

```swift
var category: String? { get }
```

### collectionName

Collection the matched image belongs to, when returned by the API.

```swift
var collectionName: String
```

### company

Company/organization name associated with the contact, if provided.

```swift
var company: String? { get }
```

### displayUrl

Best available display image URL for thumbnails and previews.

```swift
var displayUrl: URL? { get }
```

### email

Contact email address, if provided in the image metadata.

```swift
var email: String? { get }
```

### firstName

Contact first name extracted from the image metadata, if provided.

```swift
var firstName: String? { get }
```

### imageDescription

A human-readable description of the image/content, if provided.

```swift
var imageDescription: String? { get }
```

### imageID

Stable unique identifier for the image/IRCODE.

```swift
var imageID: String
```

#### Discussion

Use this to de-duplicate recognition callbacks, persist references, or perform follow-up API requests that target this specific image.

### jobTitle

Job title/role associated with the contact, if provided.

```swift
var jobTitle: String? { get }
```

### lastName

Contact last name extracted from the image metadata, if provided.

```swift
var lastName: String? { get }
```

### micrositeURL

The primary scan-to-site (“microsite”) URL for this IRCODE, if one exists.

```swift
var micrositeURL: URL? { get }
```

#### Discussion

Returns the first link flagged `onScanDisplay` that is a normal embeddable web link (not `openInNewWindow`, not `privateDetails`) and resolves to a valid URL. Returns `nil` for IRCODEs without a microsite — callers can use this to ignore non-microsite results.

### phone

Contact phone number, if provided in the image metadata.

```swift
var phone: String? { get }
```

### previewSubTitle

A short, user-friendly subtitle intended for preview cards and compact UI.

```swift
var previewSubTitle: String { get }
```

#### Discussion

Populated from the result metadata.

### previewTitle

A short, user-friendly title intended for preview cards and compact UI.

```swift
var previewTitle: String { get }
```

#### Discussion

Populated from the result metadata.

### products

Product links associated with the image, extracted from metadata.

```swift
var products: [ProductLinkModel] { get }
```

### subtitle

An optional subtitle that complements `title`, when available in metadata.

```swift
var subtitle: String? { get }
```

### tags

Tags associated with the IRCODE, useful for categorization and search.

```swift
var tags: [String] { get }
```

### title

The primary title of the image/IRCODE, when provided by metadata.

```swift
var title: String? { get }
```
