# IRKit SDK releases

Public distribution point for the **IRKit SDK** on both Apple and Android platforms.
One repository, two delivery mechanisms, kept clearly separated.

| Platform | How it ships | Where to look |
|----------|--------------|---------------|
| iOS / Apple | Swift Package Manager binary target | `main` branch `Package.swift` + [Releases](https://github.com/irdb-holdings/irkit-releases/releases) tagged `NN.NN.N` |
| Android | Maven repository (GitHub Pages) | `gh-pages` branch, served at https://irdb-holdings.github.io/irkit-releases/ + Releases tagged `android-*` |

Documentation for both platforms lives at **https://irkit-docs.web.app**.

## iOS (Swift Package Manager)

Add the package, pinned to a released version:

```swift
.package(url: "https://github.com/irdb-holdings/irkit-releases.git", exact: "26.16.0")
```

The `XCFramework` and `dSYMs` for each version are attached to the matching GitHub Release.

## Android (Gradle / Maven)

Add the Pages-hosted Maven repository in `settings.gradle.kts`:

```kotlin
dependencyResolutionManagement {
    repositories {
        google()
        mavenCentral()
        maven { url = uri("https://irdb-holdings.github.io/irkit-releases/") }
    }
}
```

Then declare the dependencies:

```kotlin
dependencies {
    implementation("com.irdb:irkit-library:2026.3.072120260825")
    implementation("com.irdb:irkit-ui:2026.3.072120260825")
    implementation("com.irdb:irkit-analytics:2026.3.072120260825")
}
```

A runnable integration sample is available at
https://github.com/irdb-holdings/irkit-android-demo.

## Release conventions

Each platform releases independently with its own tags and release notes:

- **iOS** tags use the marketing version directly: `26.16.0`.
- **Android** tags are prefixed: `android-2026.3.072120260825`.

Release titles are prefixed (`IRKit iOS …` / `IRKit Android …`) so the
[Releases page](https://github.com/irdb-holdings/irkit-releases/releases) stays scannable,
and each release carries platform-specific notes.
