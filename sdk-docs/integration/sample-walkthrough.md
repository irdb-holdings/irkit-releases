---
title: "Sample App Walkthrough"
description: "The sample app's flow, from permissions to a match"
order: 6
---

The sample app, end to end.

## 1. Configure the Project

- Add Maven host `https://irdb-holdings.github.io/irkit-releases`
- Declare IRKit + AndroidX/Compose dependencies
- Set `irkitSubscriptionKey` in `local.properties`

## 2. MainActivity (Java)

- Requests camera + location permissions
- Reads `BuildConfig.IRKIT_SUBSCRIPTION_KEY`
- Calls `IRKit.Companion.initialize(getApplicationContext(), key)` when opening the scanner
- Starts `IRKitLensActivity`

## 3. IRKitLensActivity (Kotlin)

- Creates `IREngine` from `IRKit` configuration
- Hosts `IRKitLens` full screen
- Handles recognition and product taps
- De-initializes in `onStop`

## 4. Results You Care About

- Match → convert with `imageModel.toShared()` → [ImageModelShared](../models/imagemodel-shared.md)
- If the card has products and the user taps one → `onProductClicked` with [ProductInCampaignDto](../models/product-model.md) (optional; not all cards have products)

## 5. The Tap2Scan Sample App

For the no-camera overlay, the Tap2Scan sample app is the reference. See [IRKitTap2ScanActivity](irkittap2scan-activity.md) for **minimal setup and use**.

- Add the same four IRKit AARs from published Maven
- Call `Tap2Scan.initialize` in the player Activity `onCreate`
- Host your player + `Tap2ScanLens` MATCH_PARENT sibling
- Call `setHostOwnedCapture` with the same URI and playhead ms

## Suggested Client Checklist

1. Copy Gradle repository + IRKit dependencies
2. Copy permission declarations
3. Wire subscription key via BuildConfig or your secrets store
4. Add a Compose host Activity for the lens
5. Initialize as close as possible to opening the lens → launch → deInitialize
6. Handle match callbacks; optionally handle `onProductClicked` (only fires when a card has products and one is tapped)
