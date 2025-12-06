// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "URLParser",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "URLParser",
            targets: ["URLParser"]),
    ],
    dependencies: [
        // Add any dependencies here
    ],
    targets: [
        .target(
            name: "URLParser",
            dependencies: []),
        .testTarget(
            name: "URLParserTests",
            dependencies: ["URLParser"]),
    ]
)

