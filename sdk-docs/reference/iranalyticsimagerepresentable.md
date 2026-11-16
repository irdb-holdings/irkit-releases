---
title: "IRAnalyticsImageRepresentable"
description: "A type that describes an IRCODE in an analytics event’s image parameter"
---

A type that describes an IRCODE in an analytics event’s image parameter.

```swift
protocol IRAnalyticsImageRepresentable
```

## Instance Properties

### analyticsCampaignID

```swift
var analyticsCampaignID: Int { get }
```

### analyticsCampaignName

```swift
var analyticsCampaignName: String { get }
```

### analyticsCollectionName

```swift
var analyticsCollectionName: String? { get }
```

### analyticsImageID

```swift
var analyticsImageID: String { get }
```

### analyticsImageTitle

```swift
var analyticsImageTitle: String? { get }
```

### analyticsImageURLString

```swift
var analyticsImageURLString: String? { get }
```

### analyticsRequestedLanguages

The `lang` list the scan’s lookup carried, comma-separated, most preferred first; nil when it carried none.

```swift
var analyticsRequestedLanguages: String? { get }
```

### analyticsServedLanguage

The metadata language the scan’s card was served in (the lookup’s `servedLanguage`); nil when none was asked for.

```swift
var analyticsServedLanguage: String? { get }
```

### analyticsSimilarCount

```swift
var analyticsSimilarCount: Int { get }
```

### analyticsUserIDOwner

```swift
var analyticsUserIDOwner: String? { get }
```

### analyticsUsernameOwner

```swift
var analyticsUsernameOwner: String? { get }
```
