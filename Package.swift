// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "UIExtensions",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)],
    products: [
        .library(name: "UIExtensions", targets: ["UIExtensions"]),
        .library(name: "UIExtensionsDynamic", type: .dynamic, targets: ["UIExtensions"]),
        .library(name: "UIExtensionsAllStatic", targets: ["UIExtensionsAllStatic"]),
    ],
    dependencies: [
        .package(url: "https://github.com/teufelaudio/FoundationExtensions.git", .upToNextMajor(from: "0.1.4"))
    ],
    targets: [
        .target(
            name: "UIExtensions",
            dependencies: [.product(name: "FoundationExtensions", package: "FoundationExtensions")]
        ),
        .target(
            name: "UIExtensionsAllStatic",
            dependencies: [.product(name: "FoundationExtensionsStatic", package: "FoundationExtensions")]
        ),
        .testTarget(name: "UIExtensionsTests", dependencies: ["UIExtensions"]),
    ]
)
