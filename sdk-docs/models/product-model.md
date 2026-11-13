---
title: "Product Models"
description: "The products some matched cards link to"
order: 10
---

Some matched cards include linked products; many do not. When a match has no products, the products list is empty and the user never sees a product to tap — so product handling simply does not run for that card.

> **Note:** **Products are optional.** `onProductClicked` fires only when a recognized card has one or more products _and_ the user taps one of them. If your content has no products (common for early deployments), you can still wire the callback; it simply will not be called until product data exists.

## 1. On a Match — ProductLinkShared

When products are present, `ImageModelShared.products` is a list of `com.irdb.irkit.shared.ProductLinkShared`. Otherwise the list is empty.

| Field          | Type      | Description       |
| -------------- | --------- | ----------------- |
| `id`           | `String`  | Product id        |
| `title`        | `String`  | Product name      |
| `linkToFollow` | `String`  | URL to open       |
| `imageUrl`     | `String?` | Product image URL |

## 2. When the User Taps a Product — ProductInCampaignDto

If the card shows products and the user taps one, `onProductClicked` is invoked with that product as `com.irdb.irkit.dto.ProductInCampaignDto`.

| Field          | Type      | Description       |
| -------------- | --------- | ----------------- |
| `id`           | `String?` | Product id        |
| `title`        | `String`  | Product name      |
| `linkToFollow` | `String`  | URL to open       |
| `imageUrl`     | `String`  | Product image URL |

## Example — Open Product URL

```
onProductClicked = { _, product ->
    startActivity(
        Intent(Intent.ACTION_VIEW, Uri.parse(product.linkToFollow))
    )
}
```

Convert DTO → shared with `product.toShared()` when you want a single model type in your app.
