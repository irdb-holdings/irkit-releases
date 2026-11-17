# Changelog

Releases of the IRKit Android libraries, newest first. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [2026.3.082020261126] - 2026-08-20

### Added

- [Tap2Scan](tap2scan/overview.md): viewers tap to scan the video your app is already playing, with no camera. It ships inside `com.irdb:irkit-ui`, in the `com.irdb.tap2scan` package; start with [Initialize and Layout](tap2scan/initialize-and-layout.md). Its web result links open in an in-app browser (Chrome Custom Tabs) with a Close button, except a link set to open in a new window, which goes to the default browser.

### Changed

- In the camera lens (`IRKitLens`), links tapped inside a result card’s microsite no longer all leave your app for the default browser. A link to the same site opens in the card, with a Back button. A link to another site, or one that opens a new window, opens in an in-app browser (Chrome Custom Tabs) with a Close button. Links that are not web links (`tel:`, `mailto:`, custom schemes) still go to the app that handles them. The lens still opens the card’s own links and product buttons in the default browser.
- `com.irdb:irkit-ui` now depends on `androidx.browser:browser:1.8.0` for the in-app browser. Gradle resolves it for you; see [App Dependencies](getting-started/dependencies.md).
