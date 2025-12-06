// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Assets",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Assets",
            targets: ["Assets"]),
    ],
    dependencies: [
        // Add any dependencies here
    ],
    targets: [
        .target(
            name: "Assets",
            dependencies: []),
        .testTarget(
            name: "AssetsTests",
            dependencies: ["Assets"]),
    ]
)

