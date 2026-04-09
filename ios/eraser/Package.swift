// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "eraser",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "eraser", targets: ["eraser"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "eraser",
            dependencies: []
        )
    ]
)
