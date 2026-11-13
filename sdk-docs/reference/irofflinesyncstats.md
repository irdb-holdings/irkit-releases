---
title: "IROfflineSyncStats"
description: "Summary statistics returned when offline data synchronization completes"
---

Summary statistics returned when offline data synchronization completes.

```swift
struct IROfflineSyncStats
```

## Initializers

### init(entriesAdded:entriesRemoved:failures:totalLocalRecords:aborted:)

```swift
init(entriesAdded: Int, entriesRemoved: Int, failures: Int, totalLocalRecords: Int, aborted: Bool)
```

## Instance Properties

### aborted

Whether the sync was aborted before completing.

```swift
let aborted: Bool
```

### entriesAdded

Entries added or updated during this synchronization.

```swift
let entriesAdded: Int
```

### entriesRemoved

Entries removed during this synchronization.

```swift
let entriesRemoved: Int
```

### failures

Individual non-fatal failures encountered during synchronization.

```swift
let failures: Int
```

### totalLocalRecords

Total records present in local storage after this synchronization.

```swift
let totalLocalRecords: Int
```
