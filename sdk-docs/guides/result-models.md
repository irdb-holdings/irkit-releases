---
title: "Understanding Result Models"
description: "When IRKit recognizes an image, the host app works primarily with ImageModel and the associated ProductLinkModel values"
order: 7
---

When IRKit recognizes an image, the host app works primarily with [`ImageModel`](../reference/imagemodel.md) and the associated [`ProductLinkModel`](../reference/productlinkmodel.md) values.

## `ImageModel`

`ImageModel` is the partner-facing representation of a recognized IRCODE.

Commonly used properties include:

- `imageID`: stable identifier for the recognized result
- `previewTitle`: compact title for preview cards and summary UI
- `previewSubTitle`: compact subtitle for preview cards and summary UI
- `displayUrl`: best image URL for thumbnails or hero art
- `title` and `subtitle`: richer presentation fields when available
- `artistName`, `imageDescription`, and `category`: metadata fields for detailed result UI
- `tags`: array of tags exposed from IRCODE metadata for filtering, chips, or search
- `campaignID`: identifier of the campaign this IRCODE belongs to (`0` when there is no campaign association)
- `campaignName`: human-readable campaign name when the API provides one
- `collectionName`: collection the matched image belongs to when returned by the API
- `firstName`, `lastName`, `address`, `company`, `jobTitle`, `phone`, and `email`: contact-oriented metadata when present
- `products`: associated [`ProductLinkModel`](../reference/productlinkmodel.md) entries

> **Note:** Results delivered through the optional offline recognition engine (see [Offline recognition](offline-recognition.md)) use the same `ImageModel` type as online results. The fields available depend on the data supplied by the registered engine.

### Example

```swift
func printResult(_ imageModel: ImageModel) {
    print("ID: \(imageModel.imageID)")
    print("Preview: \(imageModel.previewTitle)")
    print("Tags: \(imageModel.tags)")
    print("Products: \(imageModel.products.count)")
}
```

## `ProductLinkModel`

`ProductLinkModel` represents a shoppable product associated with a recognized image.

Its partner-facing properties are:

- `id`: stable identifier for the product entry
- `title`: display name
- `imageUrl`: optional product thumbnail URL string
- `linkToFollow`: destination URL string to open when the user selects the product

### Example

```swift
ForEach(imageModel.products) { product in
    if let url = URL(string: product.linkToFollow) {
        Link(product.title, destination: url)
    }
}
```

## Using Tags in Host Apps

Tags are exposed as `[String]` on `ImageModel`.

Typical host-app uses include:

- showing tag chips in a detail view
- filtering results in a custom catalog
- adding search keywords or analytics context

```swift
if !imageModel.tags.isEmpty {
    Text(imageModel.tags.joined(separator: ", "))
}
```
