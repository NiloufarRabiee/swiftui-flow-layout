// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "FlowLayout",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "FlowLayout",
            targets: ["FlowLayout"]
        )
    ],
    targets: [
        .target(
            name: "FlowLayout"
        ),
        .testTarget(
            name: "FlowLayoutTests",
            dependencies: ["FlowLayout"]
        )
    ]
)
