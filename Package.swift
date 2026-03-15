// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AsyncQueue",
    platforms: [
        .iOS(.v15),
        .macOS(.v11),
        .watchOS(.v8),
        .tvOS(.v15)
    ],
    products: [
        .library(
            name: "AsyncQueue",
            targets: ["AsyncQueue"]
        ),
    ],
    targets: [
        .target(
            name: "AsyncQueue"
        ),
    ]
)
