# Changelog

Releases of the IRKit Android libraries, newest first. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [2026.3.082020261126] - 2026-08-20

### Added

- [Tap2Scan](tap2scan/overview.md): viewers tap to scan the video your app is already playing, with no camera. It ships inside `com.irdb:irkit-ui`, in the `com.irdb.tap2scan` package; start with [Initialize and Layout](tap2scan/initialize-and-layout.md).
- Result links open in an in-app browser (Chrome Custom Tabs) with a Close button. `com.irdb:irkit-ui` now depends on `androidx.browser:browser:1.8.0`, which Gradle resolves for you; see [App Dependencies](getting-started/dependencies.md).
