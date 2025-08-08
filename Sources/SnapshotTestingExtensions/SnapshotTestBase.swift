// Copyright © 2025 Lautsprecher Teufel GmbH. All rights reserved.

#if canImport(SwiftUI) && canImport(SnapshotTesting)
import Foundation
import SnapshotTesting
import SwiftUI

public func assertSnapshotDevices<V: View>(
    _ view: V,
    devices: [(name: String, device: ViewImageConfig)] = [
        ("iPhoneSE3rdGen", .iPhoneSE3rdGen),
        ("iPhone16ProMax", .iPhone16ProMax),
        ("iPadMini6thGen", .iPadMini6thGen(.portrait)),
        ("iPadPro12_9", .iPadPro12_9(.portrait))
    ],
    style: Set<ColorScheme> = [.light],
    drawHierarchyInKeyWindow: Bool = false,
    precision: Float = 0.98,
    perceptualPrecision: Float = 0.98,
    record: Bool? = nil,
    timeout: TimeInterval = 5,
    allowAnimations: Bool = false,
    fileID: StaticString = #fileID,
    file: StaticString = #filePath,
    testName: String = #function,
    line: UInt = #line,
    column: UInt = #column,
    wait: TimeInterval
) {
    devices.forEach { config in
        style.forEach { colorScheme in
            let suffix = switch colorScheme {
            case .light: "-light"
            case .dark: "-dark"
            @unknown default: fatalError("Unhandled ColorScheme \(colorScheme)")
            }

            let uiStyle: UIUserInterfaceStyle = switch colorScheme {
            case .light: .light
            case .dark: .dark
            @unknown default: .unspecified
            }

            let deviceTraits = config.device.traits
            let modifiedTraits: UITraitCollection

            if #available(iOS 17.0, *) {
                modifiedTraits = deviceTraits.modifyingTraits { mutableTraits in
                    mutableTraits.userInterfaceStyle = uiStyle
                }
            } else {
                modifiedTraits = UITraitCollection(
                    traitsFrom: [
                        deviceTraits,
                        UITraitCollection(userInterfaceStyle: uiStyle)
                    ]
                )
            }

            assertSnapshot(
                of: view.environment(\.colorScheme, colorScheme),
                as: .wait(
                    for: wait,
                    on: .image(
                        drawHierarchyInKeyWindow: drawHierarchyInKeyWindow,
                        precision: precision,
                        perceptualPrecision: perceptualPrecision,
                        layout: .device(config: config.device),
                        traits: modifiedTraits
                    )
                ),
                named: nil,
                record: record,
                timeout: timeout,
                fileID: fileID,
                file: file,
                testName: "\(testName)-\(config.name)\(suffix)",
                line: line,
                column: column
            )
        }
    }
}

public func assertSnapshotDevices<V: View>(
    _ view: V,
    devices: [(name: String, device: ViewImageConfig)] = [
        ("iPhoneSE3rdGen", .iPhoneSE3rdGen),
        ("iPhone16ProMax", .iPhone16ProMax),
        ("iPadMini6thGen", .iPadMini6thGen(.portrait)),
        ("iPadPro12_9", .iPadPro12_9(.portrait))
    ],
    style: Set<ColorScheme> = [.light],
    drawHierarchyInKeyWindow: Bool = false,
    precision: Float = 0.98,
    perceptualPrecision: Float = 0.98,
    record: Bool? = nil,
    timeout: TimeInterval = 5,
    allowAnimations: Bool = false,
    fileID: StaticString = #fileID,
    file: StaticString = #filePath,
    testName: String = #function,
    line: UInt = #line,
    column: UInt = #column
) {
    devices.forEach { config in
        style.forEach { colorScheme in
            let suffix = switch colorScheme {
            case .light: "-light"
            case .dark: "-dark"
            @unknown default: fatalError("Unhandled ColorScheme \(colorScheme)")
            }

            let uiStyle: UIUserInterfaceStyle = switch colorScheme {
            case .light: .light
            case .dark: .dark
            @unknown default: .unspecified
            }

            let deviceTraits = config.device.traits
            let modifiedTraits: UITraitCollection

            if #available(iOS 17.0, *) {
                modifiedTraits = deviceTraits.modifyingTraits { mutableTraits in
                    mutableTraits.userInterfaceStyle = uiStyle
                }
            } else {
                modifiedTraits = UITraitCollection(
                    traitsFrom: [
                        deviceTraits,
                        UITraitCollection(userInterfaceStyle: uiStyle)
                    ]
                )
            }

            assertSnapshot(
                of: view.environment(\.colorScheme, colorScheme),
                as: .image(
                    drawHierarchyInKeyWindow: drawHierarchyInKeyWindow,
                    precision: precision,
                    perceptualPrecision: perceptualPrecision,
                    layout: .device(config: config.device),
                    traits: modifiedTraits
                ),
                named: nil,
                record: record,
                timeout: timeout,
                fileID: fileID,
                file: file,
                testName: "\(testName)-\(config.name)\(suffix)",
                line: line,
                column: column
            )
        }
    }
}
#endif
