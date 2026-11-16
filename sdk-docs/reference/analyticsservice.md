---
title: "AnalyticsService"
description: "Tracks analytics events and identifies the current user"
---

```swift
final class AnalyticsService
```

## Instance Methods

### setHostContext(_:)

```swift
func setHostContext(_ context: IRAnalyticsHostContext?)
```

## Type Properties

### isDebugPayloadLoggingEnabled

```swift
static var isDebugPayloadLoggingEnabled: Bool
```

### shared

```swift
static let shared: AnalyticsService
```

## Type Methods

### getQueryImageUrlForTrackingId(_:bucketName:)

```swift
static func getQueryImageUrlForTrackingId(_ trackingId: String, bucketName: String) -> String
```
