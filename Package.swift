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
            url: "https://github.com/irdb-holdings/irkit-releases/releases/download/26.14.0/IRKit.xcframework.zip",
            checksum: "3e87ff0dbfd2c6e95a55a2f53874d94d0e8fa9100ef1d5536a9e3b44f19b5501"
        )
    ]
)
