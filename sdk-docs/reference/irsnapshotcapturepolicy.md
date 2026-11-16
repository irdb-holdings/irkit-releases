---
title: "IRSnapshotCapturePolicy"
description: "Controls whether a shutter (capture) button is shown inside the Live+ lens"
---

Controls whether a shutter (capture) button is shown inside the Live+ lens.

```swift
enum IRSnapshotCapturePolicy
```

## Enumeration Cases

### IRSnapshotCapturePolicy.disabled

Never show the capture button, regardless of what the lens reports.

```swift
case disabled
```

### IRSnapshotCapturePolicy.enabled

Always show the capture button, regardless of what the lens reports.

```swift
case enabled
```

### IRSnapshotCapturePolicy.fromLens

Defer to the lens configuration. This is the default.

```swift
case fromLens
```
