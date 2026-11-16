---
title: "IROfflineRecognitionEngine"
description: "An optional, host-injected on-device recognition engine"
---

An optional, host-injected on-device recognition engine.

```swift
protocol IROfflineRecognitionEngine : AnyObject
```

## Overview

Implement this in your host app or a separate engine package, then register it through [`registerOfflineRecognitionEngine(_:)`](irvision.md#registerofflinerecognitionengine_). A host that does not integrate an engine runs online-only.

## Instance Properties

### isCatalogReady

Whether local offline data is available.

```swift
var isCatalogReady: Bool { get async }
```

## Instance Methods

### clear()

Removes local offline data from this device.

```swift
func clear() async
```

### preflight()

Performs a runtime availability check. Return `false` when the engine cannot be used.

```swift
func preflight() async -> Bool
```

### recognize(image:)

Recognize a still image on-device.

```swift
func recognize(image: UIImage) async -> IROfflineEngineMatch?
```

### recognize(pixelBuffer:)

Recognize a live camera frame on-device.

```swift
func recognize(pixelBuffer: CVPixelBuffer) async -> IROfflineEngineMatch?
```

### sync(force:onProgress:)

Synchronizes on-device data. Progress callbacks may arrive on any thread; the SDK delivers them on the main thread for UI.

```swift
@discardableResult func sync(force: Bool, onProgress: (@Sendable (IROfflineSyncProgress) -> Void)?) async throws -> IROfflineSyncStats
```
