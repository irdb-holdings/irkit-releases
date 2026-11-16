---
title: "MicrositeURLDecorator"
description: "Adds scan attribution parameters to the URLs a scan opens: pairing params on ircode.tv microsites, click and scan IDs on any other site"
---

Adds scan attribution parameters to the URLs a scan opens: pairing params on ircode.tv microsites, click and scan IDs on any other site.

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

### decorateOutbound(_:clickID:scan:)

Decorates a URL the user is opening from a scan.

```swift
static func decorateOutbound(_ url: URL, clickID: String?, scan: ScanAttribution = .currentSession) -> URL
```

#### Discussion

Microsites on ircode.tv get their pairing params from [`decorate(_:scanID:)`](micrositeurldecorator.md#decorate_scanid) and mint their own click IDs for the clicks they send on. Any other http(s) site gets `irclid` (this open’s click ID) and `irsid` (the scan’s tracking ID), which a conversion pixel or postback carries back so a sale joins to its click and scan. Pass the same `clickID` on the open’s statistics event.

Params already on the URL win, a missing value is left out rather than sent empty, and any other scheme (`tel:`, `mailto:`, app links) is returned untouched.

## Enumerations

### MicrositeURLDecorator.ScanAttribution

Which scan an open is attributed to.

```swift
enum ScanAttribution
```
