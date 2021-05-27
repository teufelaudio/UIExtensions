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
        .library(
            name: "UIExtensionsDynamic",
            type: .dynamic,
            targets: ["UIExtensionsDynamic"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/teufelaudio/FoundationExtensions.git", .upToNextMajor(from: "0.1.4"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "UIExtensions",
            dependencies: ["FoundationExtensions"]
//          Enable this for build performance warnings. Works only when building the Package, works not when building the workspace! Obey the comma.
//            , swiftSettings: [SwiftSetting.unsafeFlags(["-Xfrontend", "-warn-long-expression-type-checking=10", "-Xfrontend", "-warn-long-function-bodies=10"])]
        ),
        .target(
            name: "UIExtensionsDynamic",
            dependencies: ["FoundationExtensions"]),
        .testTarget(
            name: "UIExtensionsTests",
            dependencies: ["UIExtensions"]),
    ]
)
