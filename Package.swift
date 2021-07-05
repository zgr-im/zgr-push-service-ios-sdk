// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "ZGRImSDK",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "ZGRImSDK",
            targets:["ZGRImSDK"])
    ],
    targets:[
        .binaryTarget(
            name: "ZGRImSDK",
            url: "https://github.com/zgr-im/zgr-push-service-ios-sdk/releases/download/1.1.4/ZGRImSDK.xcframework.zip",
            checksum: "0b9a10eecb95c27d59987c72624e997df01c3a0189ced54395c0bab7fda6324d")
    ])
