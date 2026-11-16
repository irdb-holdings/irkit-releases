---
title: "IRKitLens Parameters"
description: "Every parameter IRKitLens accepts"
order: 8
---

Client-facing parameters for [`com.irdb.irkitui.IRKitLens`](irkitlens-overview.md). Defaults match the current library source.

## Required

| Parameter  | Type       | Description                                                                                                |
| ---------- | ---------- | ---------------------------------------------------------------------------------------------------------- |
| `irEngine` | `IREngine` | Recognition engine configured from [`IRKit`](../reference/irkit-api.md)`.getInstance().getConfiguration()` |

## Layout & Preview

| Parameter              | Type       | Default    | Description                                                  |
| ---------------------- | ---------- | ---------- | ------------------------------------------------------------ |
| `modifier`             | `Modifier` | `Modifier` | Size and placement; sample uses `fillMaxSize()`              |
| `useFitScaleType`      | `Boolean`  | `false`    | `false` = FILL preview, `true` = FIT                         |
| `topContentPadding`    | `Dp`       | `4.dp`     | Top inset; use `52.dp` for edge-to-edge under the status bar |
| `bottomContentPadding` | `Dp`       | `0.dp`     | Bottom inset when your Activity has its own bottom UI        |

## Callbacks

| Parameter           | Signature                                       | Default | When                                                                                           |
| ------------------- | ----------------------------------------------- | ------- | ---------------------------------------------------------------------------------------------- |
| `onImageRecognized` | `((ImageModel) -> Unit)?`                       | `null`  | Match found — convert with `toShared()` → [`ImageModelShared`](../models/imagemodel-shared.md) |
| `onProductClicked`  | `((ImageModel, ProductInCampaignDto) -> Unit)?` | `null`  | Only if the card has products and the user taps one                                            |
