---
title: "IRQualityHint"
description: "Qualitative hints describing why the current camera frame may or may not be suitable for recognition"
---

Qualitative hints describing why the current camera frame may or may not be suitable for recognition.

```swift
enum IRQualityHint
```

## Enumeration Cases

### IRQualityHint.blurry

The frame appears soft or out of focus.

```swift
case blurry
```

### IRQualityHint.good

The frame quality looks suitable for recognition.

```swift
case good
```

### IRQualityHint.motionBlur

Motion is causing streaking or blur in the frame.

```swift
case motionBlur
```

### IRQualityHint.partialOcclusion

Part of the subject is blocked or cropped out.

```swift
case partialOcclusion
```

### IRQualityHint.poorQuality

The overall frame quality is not sufficient for reliable recognition.

```swift
case poorQuality
```

### IRQualityHint.tooBright

The frame is overexposed and may lose detail.

```swift
case tooBright
```

### IRQualityHint.tooClose

The camera is too close to the subject for a clean capture.

```swift
case tooClose
```

### IRQualityHint.tooDark

The frame is underexposed and needs more light.

```swift
case tooDark
```

### IRQualityHint.tooSmall

The detected subject occupies too little of the frame.

```swift
case tooSmall
```
