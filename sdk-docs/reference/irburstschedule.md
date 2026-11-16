---
title: "IRBurstSchedule"
description: "When each frame of a scan is captured and sent, and how long the scan may take before it is called a miss"
---

When each frame of a scan is captured and sent, and how long the scan may take before it is called a miss.

```swift
struct IRBurstSchedule
```

## Initializers

### init(offsetsMs:deadline:)

```swift
init(offsetsMs: [Int], deadline: TimeInterval)
```

## Instance Properties

### deadline

Upper bound on the whole burst, in seconds.

```swift
var deadline: TimeInterval
```

#### Discussion

This limit ensures a stalled recognition request cannot leave the caller’s scanning overlay active indefinitely.

### offsetsMs

Offsets from the start of the scan, in milliseconds, at which a frame is captured and queried.

```swift
var offsetsMs: [Int]
```

#### Discussion

Every offset takes its own frame at its own moment — the host’s player is never paused for a scan — so these are different pictures of a moving scene rather than one picture sent repeatedly.

## Type Properties

### single

A single query, for callers that already hold the one frame they want scanned.

```swift
static let single: IRBurstSchedule
```

### tapToScan

Eight moments over approximately 4.5 seconds.

```swift
static let tapToScan: IRBurstSchedule
```

#### Discussion

The initial attempts cover the common case quickly. Later attempts sample the moving scene again. Attempts stop when one finds a match, and [`deadline`](irburstschedule.md#deadline) limits the total duration.
