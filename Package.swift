// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "UIExtensions",
    platforms: [.macOS(.v10_15), .iOS(.v13)],
    products: [
        .library(name: "UIExtensions", targets: ["UIExtensions"]),
        .library(name: "UIExtensionsDynamic", type: .dynamic, targets: ["UIExtensionsDynamic"]),
        .library(name: "SnapshotTestingExtensions", targets: ["SnapshotTestingExtensions"]),

    ],
    dependencies: [
        .package(url: "https://github.com/teufelaudio/FoundationExtensions.git", from: "0.5.0"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.11.0"),
        .package(url: "https://github.com/pointfreeco/swiftui-navigation.git", from: "0.6.1"),
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
        .target(
            name: "SnapshotTestingExtensions",
            dependencies: [
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
                "UIExtensions"
            ]
        ),
        .testTarget(name: "UIExtensionsTests",
                    dependencies: [
                        "SnapshotTestingExtensions",
                        "UIExtensions",
                    ]
                   ),
    ]
)
