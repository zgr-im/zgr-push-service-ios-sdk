// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "ZGRImSDK",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(name: "ZGRImSDK", targets: ["ZGRImSDK"])
    ],
    targets: [
        .binaryTarget(name: "ZGRImSDK",
                      url: "https://github.com/zgr-im/zgr-push-service-ios-sdk/releases/download/1.3.5/ZGRImSDK.xcframework.zip",
                      checksum: "016a1b5d74b65201725b43f90f7370284538c70a1b066ea66d0854e7e2e853b1")
    ]
)
