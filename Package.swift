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
            name:"ZGRImSDK",
            path: "ZGRImSDK.xcframework")
    ])
