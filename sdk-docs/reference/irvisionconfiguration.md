---
title: "IRVisionConfiguration"
description: "Configuration values used to initialize the IRKit SDK"
---

Configuration values used to initialize the IRKit SDK.

```swift
struct IRVisionConfiguration
```

## Initializers

### init(subscriptionKey:enableDebugLogging:baseURL:deviceID:environment:analyticsCompany:appSource:appVersion:userAgent:)

Initializes a custom configuration.

```swift
init(subscriptionKey: String, enableDebugLogging: Bool = false, baseURL: URL? = nil, deviceID: String? = nil, environment: IREnvironment = .production, analyticsCompany: String, appSource: String = "app", appVersion: String? = nil, userAgent: String? = nil)
```

## Instance Properties

### analyticsCompany

The company identifier associated with analytics sessions.

```swift
let analyticsCompany: String
```

### appSource

The app source identifier associated with analytics events. Defaults to `"app"`.

```swift
let appSource: String
```

### appVersion

Optional host app version associated with analytics events.

```swift
let appVersion: String?
```

### baseURL

Optional base URL for the recognition service.

```swift
let baseURL: URL?
```

### deviceID

Optional device identifier

```swift
let deviceID: String?
```

### enableDebugLogging

Enables detailed logging for debugging.

```swift
let enableDebugLogging: Bool
```

### enableDebugOptions

Enables the camera view’s debug options button and sheet. This can be set after initialization and defaults to `false`.

```swift
var enableDebugOptions: Bool
```

### environment

The service environment to use. Defaults to `.production`.

```swift
let environment: IREnvironment
```

### segmentationModelName

Selects a specific bundled segmentation model for this lens session, overriding the automatic choice. Leave `nil` (the default) to let the lens configuration select the model.

```swift
var segmentationModelName: String?
```

### subscriptionKey

Your IRCODE Enterprise subscription key required to enable IRKit features in your app.

```swift
let subscriptionKey: String
```

### userAgent

Optional host user-agent string associated with analytics events.

```swift
let userAgent: String?
```
