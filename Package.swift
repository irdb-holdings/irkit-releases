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
            url: "https://github.com/irdb-holdings/irkit-releases/releases/download/26.23.1/IRKit.xcframework.zip",
            checksum: "1fcd4cb3fdc69c23dd3bbd94b95b71860b57d29238e2c8035e9cfcac6394fe25"
        )
    ]
)
