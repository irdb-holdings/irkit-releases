---
title: "IROfflineEngineUnavailableReason"
description: "Why offline recognition is not currently usable"
---

Why offline recognition is not currently usable.

```swift
enum IROfflineEngineUnavailableReason
```

## Enumeration Cases

### IROfflineEngineUnavailableReason.notIntegrated

No engine has been registered in this build.

```swift
case notIntegrated
```

### IROfflineEngineUnavailableReason.preflightFailed

An engine is registered but its runtime validation failed.

```swift
case preflightFailed
```
