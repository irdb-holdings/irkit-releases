---
title: "IRFrameQuality"
description: "A summary of the current camera frame quality for live recognition"
---

A summary of the current camera frame quality for live recognition.

```swift
struct IRFrameQuality
```

## Instance Properties

### hints

Specific reasons that explain the current quality score.

```swift
let hints: [IRQualityHint]
```

### percentage

A normalized quality score from 0 to 100.

```swift
let percentage: Int
```
