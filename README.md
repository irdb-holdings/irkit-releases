# IRKit Android Maven repository

This branch (`gh-pages`) is served by GitHub Pages as a public Maven repository for the
IRKit Android SDK:

```
https://irdb-holdings.github.io/irkit-releases/
```

It contains the published `com.irdb:irkit-*` artifacts. It is generated content — do not
edit files here by hand. New versions are published by copying the built Maven layout into
this branch.

## Consuming the SDK (Gradle)

Add the repository in `settings.gradle.kts`:

```kotlin
dependencyResolutionManagement {
    repositories {
        google()
        mavenCentral()
        maven { url = uri("https://irdb-holdings.github.io/irkit-releases/") }
    }
}
```

Then declare the dependencies in your module `build.gradle.kts`:

```kotlin
dependencies {
    implementation("com.irdb:irkit-library:2026.3.080320261350")
    implementation("com.irdb:irkit-ui:2026.3.080320261350")
    implementation("com.irdb:irkit-analytics:2026.3.080320261350")
}
```

`irkit-logging` is pulled in transitively.

## Related surfaces

- iOS SDK (Swift Package Manager): see the `main` branch `Package.swift` and the GitHub Releases.
- Documentation (iOS + Android): https://irkit-docs.web.app
- Android sample app: https://github.com/irdb-holdings/irkit-android-demo
