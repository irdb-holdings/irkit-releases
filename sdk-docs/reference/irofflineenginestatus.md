---
title: "IROfflineEngineStatus"
description: "Runtime status of the offline recognition engine"
---

Runtime status of the offline recognition engine.

```swift
enum IROfflineEngineStatus
```

## Enumeration Cases

### IROfflineEngineStatus.notEnabled

The offline-recognition toggle is off; offline recognition is not active.

```swift
case notEnabled
```

### IROfflineEngineStatus.ready

An engine is registered, passed preflight, and is ready to use.

```swift
case ready
```

### IROfflineEngineStatus.unavailable(_:)

Offline recognition is enabled but cannot run.

```swift
case unavailable(IROfflineEngineUnavailableReason)
```
