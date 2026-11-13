---
title: "Offline Troubleshooting"
description: "Common offline issues and their fixes"
order: 23
---

## Lens Finds Nothing While Offline

- Confirm a sync completed with `Success` (or `Skipped` after a prior success) **before** opening the lens.
- Do not open the lens during the first sync — wait for the callback.
- If the device never synced successfully, there is no local collection to match against.

## `OfflineSyncResult.NotAvailable`

Offline mode is not enabled for this client / subscription. There is no app flag to flip — contact IRKit to enable offline for your account.

## `OfflineSyncResult.Failed`

- Confirm the device is online (Wi-Fi preferred).
- Confirm `IRKit.initialize` already succeeded with a valid key.
- Show `Failed.message` to the user and offer Retry.
- Keep the open-lens control disabled for offline use until a later sync succeeds.

## Sync Always Returns `Skipped`

That usually means the local collection is still within the resync window (or a sync is already running). For a forced refresh, call with `force = true`.

## Java Callback Compile / Runtime Issues

Return `kotlin.Unit.INSTANCE` from the Java lambda passed to `prepopulateOfflineData`.

## Initialize / Permissions Failures

Sync and the lens share the same prerequisites: camera and location permissions, and a non-blank subscription key. Fix those first with [Initialize IRKit](../getting-started/initialize.md) and [Troubleshooting](../help/troubleshooting.md).

## Need Library Version for Support

Use `IRKitUI.getBuildInfo()` or your sample’s `BuildConfig.IRKIT_VERSION`.
