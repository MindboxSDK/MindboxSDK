// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MindboxSDK",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "MindboxSDK",
            targets: ["MindboxSDK"]),
    ],
    dependencies: [
        .package(url: "https://github.com/mindbox-cloud/ios-sdk", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "MindboxSDK",
            dependencies: [
                .product(name: "Mindbox", package: "ios-sdk"),
                .product(name: "MindboxNotificationsService", package: "ios-sdk"),
                .product(name: "MindboxNotificationsContent", package: "ios-sdk"),
            ]),
    ]
)
