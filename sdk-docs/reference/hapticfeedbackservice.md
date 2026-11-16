---
title: "HapticFeedbackService"
description: "Service responsible for managing haptic feedback throughout the application"
---

Service responsible for managing haptic feedback throughout the application

```swift
class HapticFeedbackService
```

## Instance Methods

### triggerCaptureButtonHaptic()

Triggers a medium haptic for capture button press

```swift
func triggerCaptureButtonHaptic()
```

### triggerContinuousScanningHaptic()

Triggers a custom haptic pattern for continuous scanning

```swift
func triggerContinuousScanningHaptic()
```

### triggerErrorPattern()

Triggers an error pattern (3 quick light pulses)

```swift
func triggerErrorPattern()
```

### triggerLightPulse()

Triggers a light haptic pulse (used for Live+ scanner detection)

```swift
func triggerLightPulse()
```

### triggerModeSwitchHaptic()

Triggers a light haptic for mode switching

```swift
func triggerModeSwitchHaptic()
```

### triggerSuccessHaptic()

Triggers a medium impact haptic (used for successful IRCODE recognition)

```swift
func triggerSuccessHaptic()
```

### triggerWarningHaptic()

Triggers a warning haptic

```swift
func triggerWarningHaptic()
```

## Type Properties

### shared

Shared haptics service used by IRKit camera and result experiences.

```swift
static let shared: HapticFeedbackService
```
