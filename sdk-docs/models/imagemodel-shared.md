---
title: "ImageModelShared"
description: "The client-facing description of a matched image"
order: 9
---

`com.irdb.irkit.shared.ImageModelShared` is the stable client-facing description of a matched image. Convert from lens callbacks with `imageModel.toShared()`.

```kotlin
onImageRecognized = { imageModel ->
    val shared = imageModel.toShared()
    Log.d(TAG, shared.title ?: shared.previewTitle)
    shared.products.forEach { product ->
        Log.d(TAG, "${product.title} → ${product.linkToFollow}")
    }
}
```

## Fields

| Field                         | Type                      | Description                               |
| ----------------------------- | ------------------------- | ----------------------------------------- |
| `imageID`                     | `String`                  | Unique image id                           |
| `previewTitle`                | `String`                  | Short title for lists / cards             |
| `previewSubTitle`             | `String`                  | Short subtitle                            |
| `title`                       | `String?`                 | Full title when present                   |
| `subtitle`                    | `String?`                 | Subtitle when present                     |
| `imageDescription`            | `String?`                 | Longer description                        |
| `displayUrl`                  | `String?`                 | Display image URL                         |
| `tags`                        | `List<String>`            | Tags                                      |
| `products`                    | `List<ProductLinkShared>` | Linked products when present; often empty |
| `category`                    | `String?`                 | Category when present                     |
| `artistName`                  | `String?`                 | Artist (art cards)                        |
| `firstName` / `lastName`      | `String?`                 | Contact name                              |
| `company` / `jobTitle`        | `String?`                 | Contact org                               |
| `email` / `phone` / `address` | `String?`                 | Contact details                           |
| `campaignID`                  | `Int`                     | Campaign / collection id                  |
| `campaignName`                | `String`                  | Campaign / collection name                |

Not every field is filled for every card type. Read what you need; treat nullables as optional.
