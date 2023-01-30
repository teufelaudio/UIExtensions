// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "UIExtensions",
    platforms: [.macOS(.v10_15), .iOS(.v13)],
    products: [
        .library(name: "UIExtensions", targets: ["UIExtensions"]),
        .library(name: "UIExtensionsDynamic", type: .dynamic, targets: ["UIExtensions"]),
    ],
    dependencies: [
        .package(url: "https://github.com/teufelaudio/FoundationExtensions.git", .upToNextMajor(from: "0.2.0")),
        .package(url: "https://github.com/SwiftRex/TestingExtensions.git", .upToNextMajor(from: "0.2.7")),
        .package(url: "https://github.com/pointfreeco/swiftui-navigation.git", .upToNextMajor(from: "0.6.0"))
    ],
    targets: [
        .target(
            name: "UIExtensions",
            dependencies: [
                .product(name: "FoundationExtensions", package: "FoundationExtensions"),
                .product(name: "SwiftUINavigation", package: "swiftui-navigation"),
            ]
        ),
        .target(
            name: "UIExtensionsDynamic",
            dependencies: [
                .product(name: "FoundationExtensionsDynamic", package: "FoundationExtensions"),
                .product(name: "SwiftUINavigation", package: "swiftui-navigation"),
            ]
        ),
        .testTarget(name: "UIExtensionsTests", dependencies: ["TestingExtensions", "UIExtensions"]),
    ]
)
