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
            url: "https://github.com/irdb-holdings/irkit-releases/releases/download/26.21.0/IRKit.xcframework.zip",
            checksum: "c54f31f80d093eca5a445fec3c43891312ab0dd062bef7509a978f0b28c49cfc"
        )
    ]
)
