---
title: "IRKitLens API"
description: "The IRKitLens composable's API"
order: 12
---

Package: `com.irdb.irkitui`. Full parameter tables: [Parameters](../components/irkitlens-parameters.md).

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

Full tables: [Parameters](../components/irkitlens-parameters.md).

## Related Types

- `IREngine` — required engine
- `ImageModel` — callback payload; convert with `toShared()`
- `ImageModelShared` — stable client model
- `ProductInCampaignDto` / `ProductLinkShared` — products
