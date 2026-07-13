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
            url: "https://github.com/irdb-holdings/irkit-releases/releases/download/26.16.0/IRKit.xcframework.zip",
            checksum: "03deab805c88d61169a11ffb2a3e541490abd9339fd80b5b2b39d2ce995af665"
        )
    ]
)
