---
title: "IRKitLens API"
description: "The IRKitLens composable's API"
order: 12
---

Package: `com.irdb.irkitui`. Full parameter tables: Parameters. Hosting: [`IRKitLens`](../components/irkitlens-overview.md).

## Signature (Client-relevant)

```kotlin
@Composable
fun IRKitLens(
    irEngine: IREngine,
    modifier: Modifier = Modifier,
    useFitScaleType: Boolean = false,
    topContentPadding: Dp = 4.dp,
    onImageRecognized: ((ImageModel) -> Unit)? = null,
    onProductClicked: ((ImageModel, ProductInCampaignDto) -> Unit)? = null,
    bottomContentPadding: Dp = 0.dp
)
```

Types in the signature: [`IREngine`](irkit-api.md), [`ImageModelShared`](../models/imagemodel-shared.md) via `toShared()`, [`ProductInCampaignDto`](../models/product-model.md#2-when-the-user-taps-a-product--productincampaigndto).

## Related Types

- [`IREngine`](irkit-api.md) — required engine
- `ImageModel` — callback payload; convert with `toShared()`
- [`ImageModelShared`](../models/imagemodel-shared.md) — stable client model
- [`ProductInCampaignDto`](../models/product-model.md#2-when-the-user-taps-a-product--productincampaigndto) / [`ProductLinkShared`](../models/product-model.md#1-on-a-match--productlinkshared) — products
