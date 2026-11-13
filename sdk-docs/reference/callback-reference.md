---
title: "Callback Reference"
description: "The callbacks IRKitLens calls, and what each one receives"
order: 13
---

## onImageRecognized

`(ImageModel) -> Unit` — fired when recognition finds a match. Convert with `toShared()` for stable fields.

## onProductClicked

`(ImageModel, ProductInCampaignDto) -> Unit` — called only when a recognized card has products and the user taps one of them. Many cards have no products, so this callback often never runs; that is expected. When it does fire, use `linkToFollow` to open a browser or in-app WebView.
