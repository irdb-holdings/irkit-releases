---
title: "Automatic Switching (Online ↔ Offline)"
description: "How the lens chooses between the network and the synced collection"
order: 18
---

Once a device has synced, the lens decides for itself — moment to moment — whether to recognize using the network or using the collection already stored on the device. There is nothing to call and nothing to configure for this part; it happens automatically for the entire time `IRKitLens` is open.

> **Note:** This page is about **when** the lens uses offline recognition, not how recognition itself works internally.

## What Happens When the Device Loses Connectivity

- The lens continuously watches the device's network state in the background while it is open — not just once at launch.
- The instant a working internet connection is lost, the lens automatically continues recognizing images using the collection that was already synced to the device.
- There is no visible interruption. For an offline-capable app, the swap does not show an error, a "you're offline" banner, or any other indication to the user — scanning simply keeps working.
- No callback fires for this switch and no app code is required to make it happen — it is built into the lens.

## What Happens When Connectivity Comes Back

- As soon as the lens detects a working connection again, it automatically switches back to normal online recognition.
- Nothing needs to be re-initialized and the lens does not need to be reopened — the switch happens live while the user keeps scanning.

## "Connected" But Not Actually Working

Some networks (weak signal, captive Wi-Fi portals, etc.) report as connected to the phone even though requests can't actually get through. The lens accounts for this:

- If a recognition request can't reach the server at all (timeout / no route), the lens treats that the same as having no connection and falls back to the on-device collection.
- An ordinary "not recognized" response from the server is **not** treated as a connectivity problem — the device is still online in that case, it just didn't find a match.
- The lens keeps re-checking the real connection state, so it recovers on its own once a genuinely working connection is available again.

## Does This Apply to My App?

| Your app                 | Behavior when connectivity is lost                                                                                    |
| ------------------------ | --------------------------------------------------------------------------------------------------------------------- |
| Offline mode enabled     | Silently switches to the on-device collection; scanning keeps working with no visible message                         |
| Offline mode not enabled | Recognition simply cannot reach the server; the lens shows a network-unavailable message until the connection returns |

If you are not sure which applies to your build, call [`prepopulateOfflineData`](offline-api.md) once — a result of `NotAvailable` means offline mode (and this automatic switching) is not enabled for your account.

## Why You Still Sync Ahead of Time

Automatic switching only has something to fall back to if a sync has already completed. It does not download anything on its own the moment the network drops — by then it's too late. That's why the setup steps ask you to [sync while online, before](setup.md) the user might lose connectivity, and why the [syncing guidance](syncing.md) recommends syncing on every app launch.

> **Caution:** **Good way to verify it in testing:** confirm a sync succeeded, open the lens, then turn on Airplane Mode. Recognition should keep working with no visible change. Turn Airplane Mode back off and confirm it keeps working exactly the same way.
