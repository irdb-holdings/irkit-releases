---
title: "IROfflineEngineMatch"
description: "A match produced by a host-injected offline recognition engine"
---

A match produced by a host-injected offline recognition engine.

```swift
struct IROfflineEngineMatch
```

## Overview

The offline engine is an optional capability that a host app registers via [`registerOfflineRecognitionEngine(_:)`](irvision.md#registerofflinerecognitionengine_). When no engine is registered, the SDK runs online-only.

## Initializers

### init(entryID:similarity:payload:)

```swift
init(entryID: String, similarity: Double, payload: Data?)
```

## Instance Properties

### entryID

The matched IRCODE identifier (the engine’s entry id).

```swift
let entryID: String
```

### payload

Optional metadata supplied with the matched entry. When `nil`, the SDK returns a result containing only [`entryID`](irofflineenginematch.md#entryid) and other match data.

```swift
let payload: Data?
```

### similarity

Normalized confidence in `0...1` when the engine provides one.

```swift
let similarity: Double
```
