// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PhotoPickerWrapper",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "PhotoPickerWrapper",
            targets: ["PhotoPickerWrapper"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "PhotoPickerWrapper",
            dependencies: [])
    ]
)
