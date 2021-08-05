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
                      url: "https://github.com/zgr-im/zgr-push-service-ios-sdk/releases/download/1.2.0/ZGRImSDK.xcframework.zip",
                      checksum: "9671a43a0dd9a1c8a95ed40365967f621f63b01a5445193409d6a419f491cd08")
    ]
)
