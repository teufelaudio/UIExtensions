// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

#if canImport(UIKit) && canImport(XCTest)
import Foundation
import SnapshotTesting
import SwiftUI
import XCTest

@MainActor
open class SnapshotTestBase: XCTestCase {
    open var defaultDevices: [(name: String, device: ViewImageConfig)] {
        [
            ("SE", .iPhoneSe),
            ("X", .iPhoneX),
            ("iPadMini", .iPadMini(.portrait) ),
            ("iPadPro", .iPadPro12_9(.portrait))
        ]
    }

    open func assertSnapshotDevices<V: View>(
        _ view: V,
        devices: [(name: String, device: ViewImageConfig)]? = nil,
        style:  [UIUserInterfaceStyle] = [.unspecified],
        imageDiffPrecision: Float = 1.0,
        allowAnimations: Bool = false,
        fileID: StaticString = #fileID,
        file: StaticString = #filePath,
        testName: String = #function,
        line: UInt = #line,
        column: UInt = #column
    ) {
        (devices ?? defaultDevices).forEach { config in
            assertSnapshotDevices(
                view,
                as: .image(on: config.device, precision: imageDiffPrecision),
                style: style,
                config: config,
                allowAnimations: allowAnimations,
                fileID: fileID,
                file: file,
                testName: testName,
                line: line,
                column: column
            )
        }
    }

    open func assertSnapshotDevices<V: View>(
        _ view: V,
        devices: [(name: String, device: ViewImageConfig)]? = nil,
        style:  [UIUserInterfaceStyle] = [.unspecified],
        imageDiffPrecision: Float = 1.0,
        allowAnimations: Bool = false,
        fileID: StaticString = #fileID,
        file: StaticString = #filePath,
        testName: String = #function,
        line: UInt = #line,
        column: UInt = #column,
        wait: TimeInterval
    ) {
        (devices ?? defaultDevices).forEach { config in
            assertSnapshotDevices(
                view,
                as: .wait(for: wait, on: .image(on: config.device, precision: imageDiffPrecision)),
                style: style,
                config: config,
                preAssertionInterceptor: { vc in
                    // called to trigger rendering e.g. for AsyncImage
                    vc.viewDidAppear(false)
                },
                allowAnimations: allowAnimations,
                fileID: fileID,
                file: file,
                testName: testName,
                line: line,
                column: column
            )
        }
    }

    private func assertSnapshotDevices<V: View>(
        _ view: V,
        as snapshotting: Snapshotting<UIViewController, UIImage>,
        style:  [UIUserInterfaceStyle] = [.unspecified],
        config:  (name: String, device: ViewImageConfig),
        preAssertionInterceptor: ((UIViewController) -> Void)? = nil,
        allowAnimations: Bool,
        fileID: StaticString,
        file: StaticString,
        testName: String,
        line: UInt,
        column: UInt
    ) {
        style.forEach { uiStyle in
            let vc = UIHostingController(rootView: view)
            vc.overrideUserInterfaceStyle = uiStyle
            
            preAssertionInterceptor?(vc)
            
            let suffix: String
            switch uiStyle {
            case .unspecified:
                suffix = ""
            case .light:
                suffix = "-light"
            case .dark:
                suffix = "-dark"
            @unknown default:
                fatalError("Unhandled UIUserInterfaceStyle \(uiStyle)")
            }
            
            assertSnapshot(
                of: vc,
                as: snapshotting,
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
