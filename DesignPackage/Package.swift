// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DesignPackage",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "DesignPackage",
            targets: ["DesignPackage"]
        ),
    ],
    targets: [
        .target(
            name: "DesignPackage",
            dependencies: []
        )
    ]
)
