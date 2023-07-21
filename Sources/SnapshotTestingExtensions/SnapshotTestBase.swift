// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

#if canImport(UIKit) && canImport(XCTest)
import Foundation
import SnapshotTesting
import SwiftUI
import XCTest

open class SnapshotTestBase: XCTestCase {
    public var allowAnimations: Bool = false

    override open func setUp() {
        super.setUp()
        UIView.setAnimationsEnabled(allowAnimations)
    }

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
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line,
        wait: TimeInterval = 0.0
    ) {
        (devices ?? defaultDevices).forEach { config in
            style.forEach { uiStyle in
                let vc = UIHostingController(rootView: view)
                vc.overrideUserInterfaceStyle = uiStyle

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
                    matching: vc,
                    as: .wait(for: wait, on: .image(on: config.device, precision: imageDiffPrecision)),
                    file: file,
                    testName: "\(testName)-\(config.name)\(suffix)",
                    line: line
                )
            }
        }
    }
}
#endif
