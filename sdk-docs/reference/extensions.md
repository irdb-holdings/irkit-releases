---
title: "Extensions"
description: "IRKit's additions to SwiftUI's View and Foundation's Notification.Name"
---

## View

### irTapToScan(isActive:subscriptionKey:captureFrame:onResultLinkTapped:onWillPresentExternalContent:onDidDismissExternalContent:onScanStarted:onScanFinished:)

Overlays the tap-to-scan experience on top of this view (typically a video player). See `IRTapToScanView` for parameter semantics.

```swift
@MainActor func irTapToScan(isActive: Binding<Bool>, subscriptionKey: String? = nil, captureFrame: @escaping () -> UIImage?, onResultLinkTapped: ((IRResultLinkTapInfo) -> Bool)? = nil, onWillPresentExternalContent: (() -> Void)? = nil, onDidDismissExternalContent: (() -> Void)? = nil, onScanStarted: (() -> Void)? = nil, onScanFinished: ((Bool) -> Void)? = nil) -> some View

```

## NSNotification.Name

### irkitOfflineEngineStatusChanged

Posted whenever [`offlineEngineStatus`](irvision.md#offlineenginestatus) changes.

```swift
static let irkitOfflineEngineStatusChanged: Notification.Name
```

### irkitOfflineSyncStateChanged

Posted whenever the observable offline sync state changes — [`isSyncingOfflineCatalog`](irvision.md#issyncingofflinecatalog), [`lastOfflineSyncDate`](irvision.md#lastofflinesyncdate), or [`lastOfflineSyncStats`](irvision.md#lastofflinesyncstats).

```swift
static let irkitOfflineSyncStateChanged: Notification.Name
```
