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
                      url: "https://github.com/zgr-im/zgr-push-service-ios-sdk/releases/download/1.2.1/ZGRImSDK.xcframework.zip",
                      checksum: "17502787b13ecdddc4cc2c613fea787d32caeca393cdcf480200a7f853f7e4b4")
    ]
)
