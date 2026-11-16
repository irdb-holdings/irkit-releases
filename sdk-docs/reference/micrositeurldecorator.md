---
title: "MicrositeURLDecorator"
description: "Adds scan attribution parameters to supported microsite URLs when the host app has supplied the corresponding values"
---

Adds scan attribution parameters to supported microsite URLs when the host app has supplied the corresponding values.

```swift
enum MicrositeURLDecorator
```

## Overview

Existing query parameters are preserved.

## Type Methods

### decorate(_:scanID:)

Resolves available attribution values from the current IRKit session.

```swift
static func decorate(_ url: URL, scanID: String? = nil) -> URL
```
