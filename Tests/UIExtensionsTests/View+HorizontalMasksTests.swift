// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

#if canImport(UIKit) && canImport(XCTest)
@testable import UIExtensions
import SnapshotTesting
import SwiftUI
import XCTest

@MainActor
final class ViewHorizontalMasksTests: XCTestCase {

    func testMaskRightAndLeft() {
        let view = Color
            .red
            .maskHorizontally(leadingPadding: 20, leadingFade: 20, trailingFade: 60)
            .border(width: 10.0, edges: [Edge.leading, Edge.top, Edge.trailing, Edge.bottom], color: Color.black)
        let hostingController = UIHostingController(rootView: view.environment(\.disableAnimations, true))
        assertSnapshot(of: hostingController, as: .image(on: .iPhoneSe))
    }
}
#endif
