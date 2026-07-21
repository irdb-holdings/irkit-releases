# IRKit

Recognize IRCODE-enabled images in your app with a live camera experience or a still-image
recognition flow. IRKit is available for iOS and Android, and this repository is where you
add it to your project.

IRKit requires a subscription key, which is provided by IRCODE.

## iOS

Add IRKit to your app with the Swift Package Manager. In Xcode, choose
**File → Add Package Dependencies…** and enter this repository URL, or add it directly to
your `Package.swift`:

```swift
.package(url: "https://github.com/irdb-holdings/irkit-releases.git", exact: "26.16.0")
```

Each version ships as a prebuilt XCFramework, with matching debug symbols, attached to the
corresponding [release](https://github.com/irdb-holdings/irkit-releases/releases).

## Android

Add the IRKit repository in your `settings.gradle.kts`:

```kotlin
dependencyResolutionManagement {
    repositories {
        google()
        mavenCentral()
        maven { url = uri("https://irdb-holdings.github.io/irkit-releases/") }
    }
}
```

Then add the libraries to your app's `build.gradle.kts`:

```kotlin
dependencies {
    implementation("com.irdb:irkit-library:2026.3.072120260825")
    implementation("com.irdb:irkit-ui:2026.3.072120260825")
    implementation("com.irdb:irkit-analytics:2026.3.072120260825")
}
```

## Documentation

Full documentation for both platforms is at **https://irkit-docs.web.app**:

- [iOS SDK reference](https://irkit-docs.web.app/documentation/irkit)
- [Android SDK guide](https://irkit-docs.web.app/android/)
- [Android offline recognition](https://irkit-docs.web.app/android/offline/)

## Sample app

A runnable Android sample that integrates IRKit end to end is available at
[irkit-android-demo](https://github.com/irdb-holdings/irkit-android-demo).

## Releases

Browse all iOS and Android versions, with release notes, on the
[releases page](https://github.com/irdb-holdings/irkit-releases/releases).
