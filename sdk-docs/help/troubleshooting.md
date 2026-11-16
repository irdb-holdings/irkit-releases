---
title: "Troubleshooting"
description: "Common issues and their fixes"
order: 25
---

## Initialize Fails / Blank Key

Set `irkitSubscriptionKey` in `local.properties` and rebuild so `BuildConfig` updates. Confirm the key is non-empty at runtime.

## IRKitMissingPermissionsException

Request `CAMERA`, `ACCESS_FINE_LOCATION`, and `ACCESS_COARSE_LOCATION`, then call initialize again.

## Unresolved IRKit Dependencies

- Confirm Maven URL `https://irdb-holdings.github.io/irkit-releases` is in your repository list
- Confirm the `irkitVersion` you requested has been published on that host
- Sync Gradle / invalidate caches, then rebuild

## Compose / ClassNotFound Issues Hosting IRKitLens

Enable Compose in the module, apply the Compose compiler plugin, and align with the sample Compose BOM + `activity-compose` versions.

## Lens Opens Then Blank / Crashes After Leave

Always call `IRKitUI.deInitialize()` in the host Activity `onStop`. Re-initialize before opening the lens again.

## Tap2Scan Initialize Fails

Call `Tap2Scan.initialize(context, subscriptionKey)` with a non-blank key before constructing `Tap2ScanLens`. If `IRKit` is already initialized, the key must match.

## Tap2Scan Scan

Leave the video playing during scan. Do not pause in `onBeforeCapture`. See [Host-owned capture](../tap2scan/capture-modes.md#host-owned-capture).

## Need Library Version for Support

Use `IRKitUI.getBuildInfo()` or the sample’s `BuildConfig.IRKIT_VERSION`.
