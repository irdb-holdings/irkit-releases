---
title: "IRFrameProvider"
description: "Supplies the frame to scan"
---

Supplies the frame to scan. Always called on the main actor, and called once per burst attempt — return the frame as it is at that moment, or `nil` to skip.

```swift
typealias IRFrameProvider = @MainActor () -> UIImage?
```
