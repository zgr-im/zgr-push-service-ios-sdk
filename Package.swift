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
                      url: "https://github.com/zgr-im/zgr-push-service-ios-sdk/releases/download/1.6.1/ZGRImSDK.xcframework.zip",
                      checksum: "bdd148521dbc5ea99f3dc4d3ef37062c8403d99e7588bf9eeb9172e9bf3997ec")
    ]
)
