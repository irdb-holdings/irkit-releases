---
title: "Offline Recognition"
description: "Recognize IRCODES with no network, from a collection synced to the device ahead of time"
order: 14
---

Offline mode lets `IRKitLens` recognize images **without a network connection**. The device keeps a local copy of your IRCODE collection and matches against it on-device — ideal for arenas, stadiums, backstage areas, and other venues with poor or no connectivity.

> **Caution:** **The one rule:** Sync first, then open the lens. Offline recognition only uses what has already been synced to the device.

## At a Glance

1. Offline mode is enabled for your account — there is no client flag to turn on.
2. Initialize IRKit with your subscription / API key as usual.
3. While online (Wi-Fi preferred), call `prepopulateOfflineData` and wait for the result.
4. Then open `IRKitLens` — recognition works even if the phone has no signal.
5. The lens then automatically switches between the network and the on-device collection any time connectivity changes — see [Automatic Switching](automatic-switching.md).

## Quick Checklist

- Initialize IRKit with your subscription key.
- Sync offline data while online (Wi-Fi preferred) **before** opening the lens.
- Wait for the sync callback before enabling the lens.

## Two Public APIs

The complete offline surface for clients is two symbols. Everything else is handled inside the libraries.

| API                                               | Purpose                                            |
| ------------------------------------------------- | -------------------------------------------------- |
| `IRKit.getInstance().prepopulateOfflineData(...)` | Download / refresh the on-device IRCODE collection |
| `OfflineSyncResult`                               | Success, Skipped, NotAvailable, or Failed          |

## Related Docs

For Maven setup, initialize timing for the lens host, and `IRKitLens` parameters, see [Getting Started](../getting-started/maven-and-aars.md) and [Integration](../integration/irkitlens-activity.md).
