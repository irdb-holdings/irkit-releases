---
title: "IRKitLensActivity"
description: "Host the IRKitLens scanner in an Activity of your own"
order: 5
---

`IRKitLensActivity` is **not** a class shipped in the AARs. It is the recommended host pattern from the sample app: a Kotlin `ComponentActivity` that composes `IRKitLens` full screen.

> **Note:** Your other screens can stay Java/XML. Only the scanner screen needs Compose.

## Prerequisites

1. Subscription / API key set and app rebuilt
2. `IRKit.initialize(context, key)` already called (as close as possible to opening the lens)
3. Camera and location permissions granted

## What the Sample Does

1. Enables edge-to-edge so the camera can draw under the status bar
2. Builds one `IREngine` with configuration from `IRKit.getInstance()`
3. Composes `IRKitLens` with `topContentPadding = 52.dp`
4. Handles `onImageRecognized` and `onProductClicked`
5. Calls `IRKitUI.deInitialize()` in `onStop()`

## Minimal Host

```kotlin
class IRKitLensActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        WindowCompat.setDecorFitsSystemWindows(window, false)

        setContent {
            val context = LocalContext.current
            val irEngine = remember(context) {
                IREngine(context).apply {
                    setConfiguration(IRKit.getInstance().getConfiguration())
                }
            }

            IRKitLens(
                irEngine = irEngine,
                topContentPadding = 52.dp,
                modifier = Modifier.fillMaxSize(),
                onImageRecognized = { imageModel ->
                    val shared = imageModel.toShared()
                    // use shared.title, shared.products, …
                },
                onProductClicked = { _, product ->
                    // product.title, product.linkToFollow, product.imageUrl
                }
            )
        }
    }

    override fun onStop() {
        super.onStop()
        IRKitUI.deInitialize()
    }
}
```

## Manifest

```xml
<activity
    android:name=".IRKitLensActivity"
    android:exported="false"
    android:screenOrientation="portrait"
    android:theme="@style/Theme.YourApp.NoActionBar" />
```
