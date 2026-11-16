---
title: "IRAnalyticsHostContext"
description: "Your app’s user, attached to analytics events through setHostContext(_:)"
---

Your app’s user, attached to analytics events through [`setHostContext(_:)`](analyticsservice.md#sethostcontext_).

```swift
protocol IRAnalyticsHostContext : AnyObject
```

## Instance Properties

### userID

```swift
var userID: String { get }
```

### userType

```swift
var userType: String { get }
```
