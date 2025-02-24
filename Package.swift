// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MBAkit",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "MBAkit",
            targets: ["MBAkit-core", "MBAkit-data-manager", "MBAkit-image-loader", "MBAkit-url-session"]),
        .library(
            name: "MBAkit-core",
            targets: ["MBAkit-core"]),
        .library(
            name: "MBAkit-data-manager",
            targets: ["MBAkit-data-manager"]),
        .library(
            name: "MBAkit-image-loader",
            targets: ["MBAkit-image-loader"]),
        .library(
            name: "MBAkit-url-session",
            targets: ["MBAkit-url-session"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/MBKwon/ResultExtensions", from: "0.9.5")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "MBAkit-core",
            dependencies: ["ResultExtensions"]),
        .target(
            name: "MBAkit-data-manager"),
        .target(
            name: "MBAkit-image-loader",
            dependencies: ["ResultExtensions", "MBAkit-data-manager"]),
        .target(
            name: "MBAkit-url-session",
            dependencies: ["ResultExtensions"]),
        .testTarget(
            name: "MBAkitTests-core",
            dependencies: ["MBAkit-core"]),
    ]
)
