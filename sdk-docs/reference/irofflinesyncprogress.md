---
title: "IROfflineSyncProgress"
description: "Progress for an offline data synchronization, surfaced so a host can drive a progress UI"
---

Progress for an offline data synchronization, surfaced so a host can drive a progress UI.

```swift
struct IROfflineSyncProgress
```

## Initializers

### init(phase:completedUnitCount:totalUnitCount:)

```swift
init(phase: Phase, completedUnitCount: Int, totalUnitCount: Int)
```

## Instance Properties

### completedUnitCount

```swift
let completedUnitCount: Int
```

### fractionCompleted

Progress in `0...1`. Returns `0` while totals are unknown (manifest phase) and `1` once finished.

```swift
var fractionCompleted: Double { get }
```

### phase

```swift
let phase: Phase
```

### totalUnitCount

```swift
let totalUnitCount: Int
```

## Enumerations

### IROfflineSyncProgress.Phase

```swift
enum Phase
```
