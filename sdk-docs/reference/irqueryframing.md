---
title: "IRQueryFraming"
description: "How the query image is built from a source frame"
---

How the query image is built from a source frame.

```swift
enum IRQueryFraming
```

## Enumeration Cases

### IRQueryFraming.foveated

Three stacked zoom levels (1x, 0.5x, 0.25x) of the frame’s centre square.

```swift
case foveated
```

#### Discussion

Right for a camera capture, where the subject sits at an unknown scale in a cluttered scene and the extra zoom levels are what find it. The cost is the sides of the frame: everything outside the centre square is discarded.

### IRQueryFraming.fullFrame

The whole frame, scaled to the SDK’s query size and never upscaled.

```swift
case fullFrame
```

#### Discussion

Right for composed content — a broadcast frame, a video still — which is already framed by whoever shot it.
