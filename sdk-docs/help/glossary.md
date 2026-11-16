---
title: "Glossary"
description: "Terms used across the Android SDK docs"
order: 26
---

| Term                       | Meaning                                                                                                                                                                                 |
| -------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| AAR                        | Android Archive — the packaged library format you depend on from Maven                                                                                                                  |
| IRKit                      | Entry object for initialize / configuration — see [IRKit / IRKitUI](../reference/irkit-api.md)                                                                                          |
| IREngine                   | Recognition engine instance passed into IRKitLens — see [IRKit / IRKitUI](../reference/irkit-api.md)                                                                                    |
| IRKitLens                  | Compose scanner UI — where the camera lives; hosts preview, recognition, and match results. See [Overview](../components/irkitlens-overview.md)                                         |
| Tap2Scan                   | No-camera product: host owns media; library overlays scan + recognition. See [Tap2Scan overview](../tap2scan/overview.md)                                                               |
| Tap2ScanLens               | View overlay for Tap2Scan (MATCH_PARENT sibling above the player). See [Tap2ScanLens API](../tap2scan/tap2scanlens-api.md)                                                              |
| Host-owned capture         | Recommended Tap2Scan capture: host passes media URI + playhead; library captures the image and identifies it. See [Host-owned capture](../tap2scan/capture-modes.md#host-owned-capture) |
| Tap2ScanButtonStyle        | Scan-pill copy, colors, alignment, and padding. See [Button style](../tap2scan/button-style.md)                                                                                         |
| IRKitLensActivity          | Sample host Activity pattern for the camera lens (not a shipped library class). See [IRKitLensActivity](../integration/irkitlens-activity.md)                                           |
| IRKitTap2ScanActivity      | Sample host Activity pattern for Tap2Scan (not a shipped library class). See [IRKitTap2ScanActivity](../integration/irkittap2scan-activity.md)                                          |
| ImageModelShared           | Stable client match model via `toShared()`. See [ImageModelShared](../models/imagemodel-shared.md)                                                                                      |
| ProductLinkShared          | Product on a shared match. See [Products](../models/product-model.md#1-on-a-match--productlinkshared)                                                                                   |
| ProductInCampaignDto       | Product payload on `onProductClicked`. See [Products](../models/product-model.md#2-when-the-user-taps-a-product--productincampaigndto)                                                  |
| irkit-releases             | Public Maven host for generic client AARs                                                                                                                                               |
| API key / subscription key | Credential passed to `IRKit.initialize`                                                                                                                                                 |
