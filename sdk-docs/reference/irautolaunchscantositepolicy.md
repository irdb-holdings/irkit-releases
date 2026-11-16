---
title: "IRAutoLaunchScanToSitePolicy"
description: "Controls whether recognized IRCODEs with an embeddable scan-to-site link skip the collapsed card and expand directly into the in-card web view"
---

Controls whether recognized IRCODEs with an embeddable scan-to-site link skip the collapsed card and expand directly into the in-card web view.

```swift
enum IRAutoLaunchScanToSitePolicy
```

## Enumeration Cases

### IRAutoLaunchScanToSitePolicy.disabled

Never auto-launch, regardless of what the lens reports.

```swift
case disabled
```

### IRAutoLaunchScanToSitePolicy.enabled

Always auto-launch, regardless of what the lens reports.

```swift
case enabled
```

### IRAutoLaunchScanToSitePolicy.fromLens

Defer to the lens configuration. This is the default.

```swift
case fromLens
```
