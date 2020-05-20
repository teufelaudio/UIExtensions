// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UIExtensions",
    platforms: [
        .macOS(SupportedPlatform.MacOSVersion.v10_15),
        .iOS(SupportedPlatform.IOSVersion.v13),
        .tvOS(SupportedPlatform.TVOSVersion.v13),
        .watchOS(SupportedPlatform.WatchOSVersion.v6)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "UIExtensions",
            targets: ["UIExtensions"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name: "SwiftRex", url: "https://github.com/SwiftRex/SwiftRex", .branch("master")),
        .package(url: "https://github.com/teufelaudio/FoundationExtensions", .branch("master")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "UIExtensions",
            dependencies: [.product(name: "CombineRex", package: "SwiftRex"),
                           "FoundationExtensions"]),
        .testTarget(
            name: "UIExtensionsTests",
            dependencies: ["UIExtensions"]),
    ]
)
