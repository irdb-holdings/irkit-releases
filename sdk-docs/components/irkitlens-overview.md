---
title: "IRKitLens Overview"
description: "IRKitLens, the drop-in Compose scanner from irkit-ui"
order: 7
---

`IRKitLens` is the drop-in Compose scanner UI from `irkit-ui`. **This is where the camera lives.** When you place `IRKitLens` on screen, it owns the live camera preview, drives recognition through your `IREngine`, and presents match results — you do not build or manage a separate CameraX / camera Activity for scanning.

> **Note:** Host `IRKitLens` full screen in your lens Activity. The library opens and runs the camera inside that composable; your app supplies the engine, layout, and optional callbacks.

## What You Provide

- A configured `IREngine` (required)
- Optional callbacks for matches and products
- Layout `Modifier` (typically `Modifier.fillMaxSize()`)

## What the Library Handles

- The camera session and live preview (inside `IRKitLens`)
- Recognition against the backend / engine you configured
- Match result presentation

## Next

- [Parameter reference](irkitlens-parameters.md)
- [Callback reference](../reference/callback-reference.md)
- [Hosting pattern](../integration/irkitlens-activity.md)
