---
title: "Maven Repository & AARs"
description: "Add IRCODE's public Maven repository and the IRKit libraries to your build"
order: 2
---

IRKit publishes Android libraries (AARs) to a public Maven host. No credentials are required for the client releases repository.

**Documented library version:** `2026.3.072120260825`

## Repository

Clients **must** resolve IRKit libraries from the published Maven host. Do not use a local Maven path or file-based AAR copies.

```kotlin
maven {
    url = uri("https://irdb-holdings.github.io/irkit-releases")
}
```

Add this in `settings.gradle.kts` under `dependencyResolutionManagement.repositories` (alongside `google()` and `mavenCentral()`).

## Required AARs

All four artifacts are published under the same version. Use one version string for the whole set.

| Coordinate                 | What it provides (client view)                                                                                 |
| -------------------------- | -------------------------------------------------------------------------------------------------------------- |
| `com.irdb:irkit-logging`   | Shared logging used by the other IRKit libraries. Delivered with the release set; often resolved transitively. |
| `com.irdb:irkit-library`   | Core SDK: `IRKit`, `IREngine`, shared result models (`ImageModelShared`, products).                            |
| `com.irdb:irkit-ui`        | Scanner UI: `IRKitLens` Compose composable and `IRKitUI` helpers (`deInitialize`, build info, credits).        |
| `com.irdb:irkit-analytics` | Required companion AAR — use the same version as the other IRKit AARs                                          |

## Gradle Dependencies

```kotlin
val irkitVersion = "2026.3.072120260825" // pin the version IRKit provides

implementation("com.irdb:irkit-library:$irkitVersion")
implementation("com.irdb:irkit-ui:$irkitVersion")
implementation("com.irdb:irkit-analytics:$irkitVersion")
// irkit-logging is published with the same version and typically arrives transitively
```

> **Caution:** Pin the same `irkitVersion` for every IRKit artifact. Mixing versions is unsupported.

## Transitive Dependencies

Camera, networking, image loading, and related libraries are pulled in by the AARs. Do not re-declare those transitives unless your app already needs a different direct dependency for its own code.
