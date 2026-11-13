---
title: "What Offline Mode Is"
description: "The library downloads your IRCODE collection ahead of time and stores it on the device"
order: 15
---

The library downloads your IRCODE collection ahead of time and stores it on the device. When the lens is open, recognition runs locally against that stored collection, so matches keep working even when the phone has no signal.

## When to Use It

- Venues with unreliable or blocked cellular (arenas, stadiums, underground concourses)
- Events where guests should scan posters, merchandise, or signage without depending on the network
- Any host app that can sync while online (for example at home Wi-Fi or on venue staff Wi-Fi) before guests go offline

## What Stays the Same

- You still host `IRKitLens` the same way as the online integration.
- Match callbacks such as `onImageRecognized` still deliver results to your app.
- You still supply your subscription / API key to `IRKit.initialize`.

## What Is Different

- You must run a sync while online **before** relying on offline recognition.
- Offline recognition only covers IRCODEs that were included in the last successful sync.

> **Note:** **Account entitlement.** Offline mode is enabled for your account by IRKit — there is no app flag for you to turn on. If sync returns `NotAvailable`, contact IRKit to confirm offline is enabled for your key.

## The One Rule

> **Sync first, then open the lens.**
>
> If you open the lens before syncing has finished, the device may have nothing to match against offline.

1. App has network (Wi-Fi or cellular).
2. Run a sync and wait for it to finish.
3. _Then_ let the user open the lens.

Once that's done, the lens takes over — it watches connectivity on its own and moves between network-based and on-device recognition automatically for as long as it stays open. See [Automatic Switching](automatic-switching.md) for exactly when that happens.
