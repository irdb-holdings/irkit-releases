---
title: "AnalyticsEvent"
description: "An analytics event: a button press, link, scan, status or view"
---

```swift
enum AnalyticsEvent
```

## Enumeration Cases

### AnalyticsEvent.buttonPressed(buttonType:buttonSource:buttonTitle:buttonLink:linkToFollow:image:viewSource:viewType:durationMs:title:failed:category:)

```swift
case buttonPressed(buttonType: ButtonType, buttonSource: ButtonSource, buttonTitle: String? = nil, buttonLink: String? = nil, linkToFollow: String? = nil, image: IRAnalyticsImageRepresentable? = nil, viewSource: ViewSource? = nil, viewType: ViewType? = nil, durationMs: Double? = nil, title: String? = nil, failed: Bool = false, category: String? = nil)
```

### AnalyticsEvent.link(buttonType:image:scanTrackingID:linkToFollow:viewSource:durationMs:failed:category:)

```swift
case link(buttonType: ButtonType, image: IRAnalyticsImageRepresentable, scanTrackingID: String, linkToFollow: String, viewSource: ViewSource, durationMs: Double? = nil, failed: Bool = false, category: String? = nil)
```

### AnalyticsEvent.scan(scanType:durationMs:matched:trackingId:image:viewSource:buttonSource:buttonType:failed:category:similarCount:recognizedOffline:)

```swift
case scan(scanType: ScanType, durationMs: Double, matched: Bool, trackingId: String, image: IRAnalyticsImageRepresentable? = nil, viewSource: ViewSource? = nil, buttonSource: ButtonSource? = nil, buttonType: ButtonType? = nil, failed: Bool = false, category: String? = nil, similarCount: Int? = nil, recognizedOffline: Bool = false)
```

### AnalyticsEvent.status(statusType:durationMs:image:)

```swift
case status(statusType: StatusType, durationMs: Double? = nil, image: IRAnalyticsImageRepresentable? = nil)
```

### AnalyticsEvent.view(viewType:viewSource:durationMs:image:timeToDisplayMs:)

```swift
case view(viewType: ViewType, viewSource: ViewSource, durationMs: Double, image: IRAnalyticsImageRepresentable? = nil, timeToDisplayMs: Double? = nil)
```

## Instance Properties

### eventName

```swift
var eventName: String { get }
```

### parameters

```swift
var parameters: [String : Any] { get }
```

## Enumerations

### AnalyticsEvent.ButtonSource

```swift
enum ButtonSource
```

### AnalyticsEvent.ButtonType

```swift
enum ButtonType
```

### AnalyticsEvent.ScanType

```swift
enum ScanType
```

### AnalyticsEvent.StatusType

```swift
enum StatusType
```

### AnalyticsEvent.ViewSource

```swift
enum ViewSource
```

### AnalyticsEvent.ViewType

```swift
enum ViewType
```
