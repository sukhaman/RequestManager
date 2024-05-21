// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RequestManager",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "RequestManager",
            targets: ["RequestManager"]),
    ],
    dependencies: [
        // Add dependencies here
    ],
    targets: [
        .binaryTarget(name: "RequestManager", path: "./Sources/RequestManager/RequestManager.xcframework")
        ,
        .testTarget(
            name: "RequestManagerTests",
            dependencies: ["RequestManager"]),
    ]
)
