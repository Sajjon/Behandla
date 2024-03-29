// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Behandla",
    platforms: [
        .macOS(.v10_13), .iOS(.v9)
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/onevcat/Rainbow", from: "3.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Behandla",
            dependencies: ["Core"],
            path: "Sources/Behandla"
        ),

        .target(
            name: "Core",
            dependencies: ["Rainbow"],
            path: "Sources/Core"
        ),

        .testTarget(
            name: "BehandlaTests",
            dependencies: ["Behandla", "Core"]),
    ]
)
