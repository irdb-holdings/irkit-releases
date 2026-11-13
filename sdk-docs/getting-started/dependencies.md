---
title: "App Dependencies"
description: "The AndroidX and Compose libraries an app needs beside the IRKit libraries"
order: 3
---

Beyond the IRKit AARs, the sample app declares AndroidX and Compose libraries so a traditional Java/XML app can host the Compose-based `IRKitLens`.

## IRKit Artifacts

| Dependency                 | Version             | Why                                   |
| -------------------------- | ------------------- | ------------------------------------- |
| `com.irdb:irkit-library`   | same `irkitVersion` | Initialize SDK and recognition engine |
| `com.irdb:irkit-ui`        | same                | Host `IRKitLens`                      |
| `com.irdb:irkit-analytics` | same                | Required companion AAR (same version) |
| `com.irdb:irkit-logging`   | same (shipped)      | Logging support for the IRKit stack   |

## Core Android (Host UI)

| Dependency                                   | Version in sample | Why needed                                           |
| -------------------------------------------- | ----------------- | ---------------------------------------------------- |
| `androidx.core:core-ktx`                     | 1.16.0            | Kotlin Android extensions used across host + Compose |
| `androidx.appcompat:appcompat`               | 1.6.1             | Java `AppCompatActivity` entry screen                |
| `com.google.android.material:material`       | 1.11.0            | Material widgets on the host screen                  |
| `androidx.constraintlayout:constraintlayout` | 2.1.4             | XML layout for the sample main screen                |

## Compose (Required to Host IRKitLens)

`IRKitLens` is a `@Composable`. Your lens screen must be a Kotlin `ComponentActivity` that calls `setContent { ... }`. Other screens may stay Java/XML.

| Dependency                                     | Version in sample | Why needed                                            |
| ---------------------------------------------- | ----------------- | ----------------------------------------------------- |
| Compose BOM `androidx.compose:compose-bom`     | 2025.01.00        | Aligns Compose artifact versions; use `platform(...)` |
| `androidx.compose.ui:ui`                       | via BOM           | Compose UI primitives                                 |
| `androidx.compose.foundation:foundation`       | via BOM           | Layout helpers used with the lens host                |
| `androidx.compose.material3:material3`         | via BOM           | Material3 theming for Compose host screens            |
| `androidx.activity:activity-compose`           | 1.10.1            | `setContent` bridge from Activity → Compose           |
| `androidx.lifecycle:lifecycle-runtime-compose` | 2.9.0             | Lifecycle-aware Compose runtime                       |

> **Note:** Prefer the sample’s Compose BOM and activity-compose versions when integrating. Mismatched Compose stacks are a common source of runtime crashes.

## Gradle Plugins (Sample)

- `com.android.application` AGP 8.13.2
- `org.jetbrains.kotlin.android` 2.2.21
- `org.jetbrains.kotlin.plugin.compose` 2.2.21 — required when Compose is enabled
