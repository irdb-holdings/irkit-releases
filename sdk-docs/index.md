---
title: "Android SDK"
description: "Put IRCODE scanning in your Android app with the IRKit libraries"
order: 0
---

Add the IRKit Maven libraries to your Android app, initialize with your API key, and host `IRKitLens` — the Compose UI where the camera lives. Examples match the the sample app sample.

> **Note:** **You must supply your API key.** Add the AARs, call `IRKit.initialize(context, apiKey)` with the subscription key IRKit provides you, then open `IRKitLens`.

## Integration at a Glance

1. Add the Maven repository `https://irdb-holdings.github.io/irkit-releases`
2. Depend on `irkit-library`, `irkit-ui`, and `irkit-analytics` (plus delivered `irkit-logging`)
3. Declare camera / network / location permissions
4. Call `IRKit.initialize(context, apiKey)` with your IRKit-issued subscription / API key — as close as possible to opening `IRKitLens`
5. Host `IRKitLens` in a Compose `ComponentActivity`
6. Call `IRKitUI.deInitialize()` when leaving the scanner

## Sample App

The sample app is a Java/XML host shell plus a Kotlin `IRKitLensActivity`. See the [Sample Walkthrough](integration/sample-walkthrough.md).
