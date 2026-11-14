---
title: "Tap2ScanButtonStyle"
description: "Restyle the Tap2Scan button"
order: 12
---

`com.irdb.tap2scan.Tap2ScanButtonStyle` controls copy, colors, typography, icon, and on-screen placement of the scan pill. Defaults match the “SCAN WITH IRCODE” pill. Apply with [`Tap2ScanLens.setButtonStyle`](tap2scanlens-api.md).

> **Note:** Hosts that only need top/end placement can call `Tap2ScanLens.setScanButtonPadding(topDp, endDp)` instead of building `PaddingValues` themselves.

## Fields

| Field             | Default            | Description                                                                                                                                                                                                            |
| ----------------- | ------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `leadingText`     | `"SCAN WITH"`      | Text before the mark                                                                                                                                                                                                   |
| `trailingText`    | `"IRCODE"`         | Text after the mark                                                                                                                                                                                                    |
| `iconRes`         | `null`             | Optional drawable; `null` uses the built-in IRCODE scan mark                                                                                                                                                           |
| `showIcon`        | `true`             | Whether to draw the mark                                                                                                                                                                                               |
| `alignment`       | `Alignment.TopEnd` | Where the pill sits on the overlay                                                                                                                                                                                     |
| `padding`         | `16.dp` top + end  | Outer margin from overlay edges. **Top** is measured from below the status bar when it is visible (or from the top of the window when hidden). The library always adds the live status-bar inset on top of this value. |
| `contentPadding`  | library default    | Inner padding of the pill                                                                                                                                                                                              |
| `backgroundColor` | library default    | Pill fill                                                                                                                                                                                                              |
| `contentColor`    | library default    | Text / icon color                                                                                                                                                                                                      |
| `iconAccentColor` | same as background | Vertical bar / cutout inside the default mark                                                                                                                                                                          |
| `cornerRadius`    | library default    | Pill corner radius                                                                                                                                                                                                     |
| `fontSizeSp`      | library default    | Type size in sp                                                                                                                                                                                                        |
| `fontWeight`      | `FontWeight.Bold`  | Leading “SCAN WITH” weight                                                                                                                                                                                             |
| `letterSpacing`   | library default    | Letter spacing                                                                                                                                                                                                         |
| `iconSize`        | library default    | Mark size                                                                                                                                                                                                              |
| `itemSpacing`     | library default    | Gap between leading text, mark, and trailing text                                                                                                                                                                      |

`Tap2ScanButtonStyle.DEFAULT` is the default instance. Apply with:

```
tap2ScanLens.setButtonStyle(
    Tap2ScanButtonStyle(
        leadingText = "SCAN WITH",
        trailingText = "IRCODE",
        alignment = Alignment.TopEnd,
    )
)
```

Related type: [`Tap2ScanLens`](tap2scanlens-api.md).
