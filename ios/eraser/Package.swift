// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "eraser",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "eraser", targets: ["eraser"])
    ],
    dependencies: [
        // Resolved by the Flutter tool when the package is built as part of an app.
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "eraser",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ]
        )
    ]
)
