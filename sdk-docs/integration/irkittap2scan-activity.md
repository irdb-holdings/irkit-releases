---
title: "IRKitTap2ScanActivity"
description: "Host the Tap2Scan lens over your video player in an Activity of your own"
order: 7
---

`IRKitTap2ScanActivity` is **not** a class shipped in the AARs. It is the recommended host pattern from the Tap2Scan sample app: a Kotlin `ComponentActivity` that hosts **your** media player plus a MATCH_PARENT [`Tap2ScanLens`](../tap2scan/tap2scanlens-api.md) overlay.

> **Note:** Your other screens can stay Java/XML. Only this player screen needs Compose (or a `FrameLayout` with `PlayerView` + `Tap2ScanLens`). Do not open a camera Activity for Tap2Scan.

## Prerequisites

1. Subscription / API key set and app rebuilt (never hardcode it)
2. [`Tap2Scan.initialize(context, key)`](../tap2scan/initialize-and-layout.md) called in this Activity `onCreate` — as close as possible to showing the overlay, not in `Application.onCreate`
3. A media URI the player will play (HLS, file, or other). You will pass the **same** string to [`setHostOwnedCapture`](../tap2scan/capture-modes.md#host-owned-capture)

## What the Sample Does

1. Enables edge-to-edge so the SCAN pill can measure from the window top
2. Calls `Tap2Scan.initialize` immediately before composing the overlay
3. Puts the host player full screen (sample uses Media3 `PlayerView` — any View + playhead ms works)
4. Overlays `Tap2ScanLens` MATCH_PARENT; pads the overlay for the navigation bar only
5. Calls `setHostOwnedCapture` with the same URI and `player.currentPosition`
6. Handles `setOnImageRecognized`, `setOnNoMatch`, and `setOnCardsDismissed`

Copy the pattern, not the sample chrome (back button, no-match toast, landscape lock).

## Minimal Setup and Use

```kotlin
class IRKitTap2ScanActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        WindowCompat.setDecorFitsSystemWindows(window, false)

        val subscriptionKey = /* BuildConfig / secrets — required, non-blank */
        val streamUrl = /* same URI the player will play */
        Tap2Scan.initialize(this, subscriptionKey)

        setContent {
            val context = LocalContext.current
            val player = remember {
                ExoPlayer.Builder(context).build().apply {
                    setMediaItem(MediaItem.fromUri(streamUrl))
                    prepare()
                    playWhenReady = true
                }
            }
            DisposableEffect(player) {
                onDispose { player.release() }
            }

            Box(Modifier.fillMaxSize()) {
                AndroidView(
                    factory = { ctx ->
                        PlayerView(ctx).apply { this.player = player }
                    },
                    modifier = Modifier
                        .fillMaxSize()
                        .statusBarsPadding(),
                )
                AndroidView(
                    factory = { ctx -> Tap2ScanLens(ctx) },
                    update = { lens ->
                        lens.setHostOwnedCapture(
                            mediaUri = streamUrl,
                            positionMs = { player.currentPosition },
                            onBeforeCapture = {
                                // hide player chrome; do not pause
                            },
                        )
                        lens.setOnNoMatch { /* restore chrome */ }
                        lens.setOnCardsDismissed { /* restore chrome */ }
                        lens.setOnImageRecognized { shared: ImageModelShared ->
                            // shared.imageID, shared.previewTitle, shared.products
                        }
                    },
                    modifier = Modifier
                        .fillMaxSize()
                        .navigationBarsPadding(),
                )
            }
        }
    }
}
```

Types used above: [`Tap2Scan`](../tap2scan/overview.md), [`Tap2ScanLens`](../tap2scan/tap2scanlens-api.md), [`ImageModelShared`](../models/imagemodel-shared.md).

XML / View hosts: skip Compose. Put `PlayerView` (or your player view) and `Tap2ScanLens` as MATCH_PARENT siblings in a `FrameLayout`, call `Tap2Scan.initialize` in `onCreate`, then the same setters after `setContentView`.

> **Caution:** Do not pause playback in `onBeforeCapture`. Leave the video playing during the scan. Full capture guide: [Host-owned capture](../tap2scan/capture-modes.md#host-owned-capture).

## Manifest

```xml
<activity
    android:name=".IRKitTap2ScanActivity"
    android:exported="false"
    android:configChanges="orientation|screenSize|screenLayout|smallestScreenSize|keyboardHidden"
    android:theme="@style/Theme.YourApp.NoActionBar" />
```

If you declare `android:configChanges` so rotation does not recreate the Activity, call `ViewCompat.requestApplyInsets(window.decorView)` in `onConfigurationChanged` so the SCAN pill re-measures.

## Next

- [Initialize & layout](../tap2scan/initialize-and-layout.md)
- [Host-owned capture](../tap2scan/capture-modes.md#host-owned-capture)
- [Tap2ScanLens API](../tap2scan/tap2scanlens-api.md)
