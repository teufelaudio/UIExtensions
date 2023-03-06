// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "UIExtensions",
    platforms: [.macOS(.v10_15), .iOS(.v13)],
    products: [
        .library(name: "UIExtensions", targets: ["UIExtensions"]),
        .library(name: "UIExtensionsDynamic", type: .dynamic, targets: ["UIExtensionsDynamic"]),
        .library(name: "SnapshotTestingExtensions", targets: ["SnapshotTestingExtensions"]),
        .library(name: "SnapshotTestingExtensionsDynamic", type: .dynamic, targets: ["SnapshotTestingExtensionsDynamic"]),

    ],
    dependencies: [
        .package(url: "https://github.com/teufelaudio/FoundationExtensions.git", from: "0.3.0"),
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
            ]
        ),
        .target(
            name: "SnapshotTestingExtensionsDynamic",
            dependencies: [
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
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
