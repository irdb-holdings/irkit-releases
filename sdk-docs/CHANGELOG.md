# Changelog

Releases of IRKit for iOS, newest first. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [26.23.1] - 2026-11-04

The lens recognizes in all four orientations: what the user sees in the camera is what reaches the engine, upright, however the phone is held.

### Fixed

- Fixed an issue where holding the phone in an orientation the host's interface does not rotate to (upside down, sideways in a portrait-only app, or iPhone Duo held open) sent query images to the engine rotated by a quarter or half turn. Live queries, snapshots and Gaze Bounding Mode captures are now turned upright before they are sent, using the gravity-based capture angle from `AVCaptureDevice.RotationCoordinator`. The preview, the frozen still and the gaze box are unchanged and still line up with the screen.
- Removed the "Please hold your phone upright" prompt from `IRCameraView`, since every orientation now recognizes correctly.

## [26.23.0] - 2026-11-04

Multilingual results, conversion-ready outbound links, the new api.ircode.com hosts, and a camera preview that stays upright on iPhone Duo's inner display.

### Added

- Lookups request the device's preferred languages; result cards are labelled in the served language and can switch to another language by asking the lookup again, so drafts and private-account IRCODEs that a public SDK key can't fetch by ID still switch. Rows from a master template are read in the template's language.
- Scan statistics report `servedLanguage` and `requestedLanguages`, so it is visible where a visitor's language has no translation.
- Outbound opens from a scan carry the click and scan IDs a conversion joins on: links to any site but ircode.tv get `irclid` and `irsid`, and the matching link, button or scan event sends the same `clickID`. `IRResultLinkTapInfo.url` and an `identifyImage` match's `micrositeURL` come back decorated, so host apps need no change.
- Tapping a result card that opens its site inside the card is reported as `link(tapped)` with `linkToFollow` and the embedded page's click ID. Tap to Scan's takeover and a live card forced open in landscape send `link(autoOpen)`.
- Lenses can show art-card results (artist, title, year, medium and the rest of the artwork's details) when the host opts in with `IRVisionConfiguration.showsArtCards`. It is off by default, which keeps treating art-card matches as no result.
- The SDK calls `https://[dev.|staging.]api.ircode.com/v1` and `https://stats.[dev.|staging.]api.ircode.com/v1` instead of versioned Cloud Function names, so a backend version can be retired without an app update.

### Fixed

- Fixed an issue where the lens camera preview, and the frames sent for recognition, were rotated by 90 degrees on iPhone Duo's inner display, whichever way the device was held. Capture rotation now comes from `AVCaptureDevice.RotationCoordinator` for the display the preview is on, and is re-read when the device is folded or unfolded.
- Fixed an issue where result-card links to other sites opened on a black screen until the first touch. Safari is now presented modally from the top view controller, and the camera or host player still pauses and resumes around it.
- Fixed an issue where the collapsed result card led with the owner's user name instead of the title for IRCODEs outside a campaign.

## [26.22.1] - 2026-09-15

### Fixed

- Fixed an issue where embedded result-card web content was forced to a light color scheme regardless of the page's own theme or the system appearance.
- Fixed an issue where concurrent access to `IRVision` tracking identifiers could crash the host app during a scan.
- Fixed an issue where tap-to-scan could abort immediately when the first video frame was not yet available.

## [26.22.0] - 2026-09-02

Hardens scan tracking and analytics concurrency so recognition sessions keep a single stable tracking identifier under concurrent access.

### Fixed

- Fixed an issue where concurrent reads and writes of scan tracking identifiers could produce inconsistent or duplicate tracking IDs for the same recognition session.
- Fixed an issue where analytics host context updates and application lifecycle notifications could race inside `AnalyticsService`.

## [26.21.0] - 2026-08-06

### Added

- Tap-to-scan supports burst recognition over live and on-demand video through `IRTapToScanView` and `IRVision/identifyImage(schedule:framing:firstFrame:captureFrame:)`, sampling multiple frames while playback continues.
- `IRCameraView` exposes `IRSnapshotCapturePolicy` to defer snapshot capture to the active lens configuration or force it on or off.

### Changed

- Still-image recognition now uses foveated framing by default, while burst recognition uses full-frame framing for composed video content.
- Segmentation model selection now follows the active lens configuration and falls back to a default model when no model is specified.

### Fixed

- Fixed an issue where segmentation could remain disabled when lens characteristics were unavailable.

## [26.20.0] - 2026-07-30

This release isolates SDK state per Lens, so hosts that switch between subscription keys no longer carry configuration from one Lens into another. It also adds microsite scan attribution and improves offline recognition.

### Added

- IRKit now namespaces mutable state by subscription key. Debug options, the offline recognition toggle, the registered offline engine, catalog caches, and cached IREngine credentials each belong to the Lens that created them. Passing a different subscription key to `IRVision.configure(with:)` activates that Lens's own state rather than inheriting the previous Lens's configuration. Reconfiguring with the same key preserves that Lens's state, including a previously enabled offline toggle.
- Added `MicrositeURLDecorator`, which appends `userID`, `scanID`, and `source` query parameters to `ircode.tv` links so a microsite visit can be attributed to the scan that produced it. Parameters already present on the URL are left untouched, and non-`ircode.tv` URLs are returned unchanged.
- Analytics events now identify Tap to Scan activity through a dedicated `tap2scan` scan type and view type.

### Changed

- Offline catalog synchronization transfers listing records instead of complete image objects, reducing download size and memory use during sync.
- Analytics events carry a canonical scan tracking identifier, allowing a scan to be correlated with the events that follow it. The `scanTrackingID` parameter is now omitted when no identifier is available, rather than being sent as an empty value.
- The offline recognition documentation describes how `ImageModel` is hydrated from an engine payload, and a new section covers configuring multiple Lenses in a single host.
- A complete `IROfflineRecognitionEngine` implementation is available as a sample adapter, showing how to back offline recognition with an on-device engine.

### Fixed

- Fixed an issue where the "No match found" notice could appear at the same time as a successful recognition result.
- Fixed an issue where an offline match could return empty tags when the synced catalog contained partial image records. IRKit now hydrates whatever metadata the payload provides, and falls back to a model carrying only the entry identifier when the engine returns no payload.
