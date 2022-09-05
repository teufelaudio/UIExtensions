// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "UIExtensions",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)],
    products: [
        .library(name: "UIExtensions", targets: ["UIExtensions"]),
        .library(name: "UIExtensionsDynamic", type: .dynamic, targets: ["UIExtensions"]),
    ],
    dependencies: [
        .package(url: "https://github.com/teufelaudio/FoundationExtensions.git", .exact("0.1.17")),
        .package(url: "https://github.com/SwiftRex/TestingExtensions.git", .upToNextMajor(from: "0.2.7"))
    ],
    targets: [
        .target(
            name: "UIExtensions",
            dependencies: [.product(name: "FoundationExtensions", package: "FoundationExtensions")]
        ),
        .target(
            name: "UIExtensionsDynamic",
            dependencies: [.product(name: "FoundationExtensionsDynamic", package: "FoundationExtensions")]
        ),
        .testTarget(name: "UIExtensionsTests", dependencies: ["TestingExtensions", "UIExtensions"]),
    ]
)
