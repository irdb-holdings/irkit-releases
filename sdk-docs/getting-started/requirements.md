---
title: "Requirements"
description: "The Android version, hardware and permissions IRKit needs"
order: 1
---

Hardware, OS, and permission requirements match what the sample app uses successfully.

## Android OS & SDK

| Setting       | Value (the sample app) | Notes                      |
| ------------- | ---------------------- | -------------------------- |
| `minSdk`      | **33**                 | Android 13+                |
| `compileSdk`  | 35                     | Match or exceed the sample |
| `targetSdk`   | 35                     | Match or exceed the sample |
| Java / Kotlin | 17                     | JVM target 17              |

## Hardware

- Rear camera required — declare `android.hardware.camera` with `android:required="true"`
- Portrait orientation recommended for the lens Activity

## Manifest Permissions

From the sample app `AndroidManifest.xml`:

| Permission                                | Why                                   |
| ----------------------------------------- | ------------------------------------- |
| `CAMERA`                                  | Live camera preview and recognition   |
| `INTERNET`                                | Recognition and library network calls |
| `ACCESS_NETWORK_STATE`                    | Connectivity checks                   |
| `ACCESS_FINE_LOCATION`                    | Location context for recognition      |
| `ACCESS_COARSE_LOCATION`                  | Location context (request with fine)  |
| `com.google.android.gms.permission.AD_ID` | Required by the IRKit libraries       |

## Runtime Permission Flow

Before opening the lens, grant at least camera and location (fine + coarse). The sample app requests them from `MainActivity` and only starts `IRKitLensActivity` when they are granted.

`IRKit.initialize` may throw `IRKitMissingPermissionsException` if required permissions are still missing — catch it, request permissions, then retry.

## Build Tooling (Sample)

- Android Gradle Plugin `8.13.2`
- Kotlin `2.2.21` with Compose compiler plugin
- Gradle wrapper `8.13`
