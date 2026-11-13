---
title: "Sending Analytics Events"
description: "Use AnalyticsService to read or extend the analytics stream associated with IRKit experiences"
order: 9
---

Use [`AnalyticsService`](../reference/analyticsservice.md) to read or extend the analytics stream associated with IRKit experiences.

## Overview

IRKit records analytics for its camera and recognition experiences. The public analytics API lets hosts add events for UI and recognition flows outside the SDK-provided views.

Most host apps do not need to do anything to benefit from this — the SDK records its own events automatically once [`configure(with:)`](../reference/irvision.md#configurewith) has run. The public surface described below exists for hosts that want to:

- attach their own user identity to IRKit’s events
- emit additional `view` / `buttonPressed` / `link` / `status` events from host UI that lives outside `IRCameraView`
- pass their own image-like model into events when the recognition source is the host’s own data

## Identifying the Current User

Implement [`IRAnalyticsHostContext`](../reference/iranalyticshostcontext.md) and pass the conformance to [`setHostContext(_:)`](../reference/analyticsservice.md#sethostcontext_) once your app knows who the user is.

```swift
import IRKit

final class IRKitAnalyticsBridge: IRAnalyticsHostContext {
    var userID: String { CurrentSession.shared.accountID ?? "" }
    var userType: String { CurrentSession.shared.isPremium ? "premium" : "guest" }
}

let bridge = IRKitAnalyticsBridge()
AnalyticsService.shared.setHostContext(bridge)
```

Call [`identifyCurrentUser()`](../reference/analyticsservice.md) after sign-in or sign-out so the analytics service can refresh its user context.

```swift
AnalyticsService.shared.identifyCurrentUser()
```

Pass `nil` to [`setHostContext(_:)`](../reference/analyticsservice.md#sethostcontext_) when the user signs out.

## Sending an Event

[`trackEvent(_:)`](../reference/analyticsservice.md) accepts an [`AnalyticsEvent`](../reference/analyticsevent.md). The event enum encodes the event family (`scan`, `view`, `buttonPressed`, `link`, `status`) and its parameters at the type level, so the compiler enforces required fields per event type.

```swift
import IRKit

AnalyticsService.shared.trackEvent(
    .view(
        viewType: .expanded,
        viewSource: .liveScan,
        durationMs: 1_240,
        image: lastRecognizedImage
    )
)
```

The full set of event families and their parameter enums is on [`AnalyticsEvent`](../reference/analyticsevent.md):

- [`AnalyticsEvent.ScanType`](../reference/analyticsevent.md#analyticseventscantype) — `creator`, `live`, `snapshot`
- [`AnalyticsEvent.ViewType`](../reference/analyticsevent.md#analyticseventviewtype) — `compressed`, `expanded`, `full`
- [`AnalyticsEvent.ViewSource`](../reference/analyticsevent.md#analyticseventviewsource) — where the view originated (`liveScan`, `snapshot`, `history`, `myIrcodes`, …)
- [`AnalyticsEvent.ButtonType`](../reference/analyticsevent.md#analyticseventbuttontype) and [`AnalyticsEvent.ButtonSource`](../reference/analyticsevent.md#analyticseventbuttonsource) — for `buttonPressed` and `link` events
- [`AnalyticsEvent.StatusType`](../reference/analyticsevent.md#analyticseventstatustype) — for session-level events (`sessionStarted`, `imageSaved`, `userAccountCreated`, …)

## Attaching a Recognized Image

Events that take an `image:` parameter expect an [`IRAnalyticsImageRepresentable`](../reference/iranalyticsimagerepresentable.md). [`ImageModel`](../reference/imagemodel.md) already conforms to this protocol, so you can pass any recognized result directly:

```swift
AnalyticsService.shared.trackEvent(
    .buttonPressed(
        buttonType: .save,
        buttonSource: .irCodeView,
        image: recognizedImage
    )
)
```

If your host app maintains its own data type for IRCODE-like content (for example, a saved-content row that doesn’t carry a full `ImageModel`), conform that type to [`IRAnalyticsImageRepresentable`](../reference/iranalyticsimagerepresentable.md) and pass it the same way.

```swift
extension SavedIRCodeRow: IRAnalyticsImageRepresentable {
    var analyticsImageID: String { ircodeID }
    var analyticsImageTitle: String? { displayTitle }
    var analyticsImageURLString: String? { thumbnailURL?.absoluteString }
    var analyticsCollectionName: String? { collectionName }
    var analyticsCampaignID: Int { campaignID ?? 0 }
    var analyticsCampaignName: String { campaignName ?? "" }
    var analyticsSimilarCount: Int { 0 }
    var analyticsUserIDOwner: String? { nil }
    var analyticsUsernameOwner: String? { nil }
}
```
