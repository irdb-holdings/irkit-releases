// swift-tools-version: 5.9
import PackageDescription

// onnxruntime is statically linked into IRKit.xcframework — no separate
// binary target is needed for the ONNX runtime.

let package = Package(
    name: "IRKit",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "IRKit",
            targets: ["IRKit"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "IRKit",
            url: "https://github.com/irdb-holdings/irkit-releases/releases/download/26.14.1/IRKit.xcframework.zip",
            checksum: "f682d64d99855bd5182e288f02171a412d903d4590c01de715723c7c92339453"
        )
    ]
)
