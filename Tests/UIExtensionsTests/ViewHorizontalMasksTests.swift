// Copyright © 2021 Lautsprecher Teufel GmbH. All rights reserved.

@testable import UIExtensions
import TestingExtensions
import SnapshotTesting
import SwiftUI
import XCTest

final class ViewHorizontalMasksTests: SnapshotTestBase {

    func testMaskRightAndLeft() {
        let view = Color
            .red
            .maskHorizontally(leadingPadding: 20, leadingFade: 20, trailingFade: 60)
            .border(width: 10.0, edges: [Edge.leading, Edge.top, Edge.trailing, Edge.bottom], color: Color.black)
        assertSnapshotDevices(view.environment(\.disableAnimations, true), devices: [("SE", .iPhoneSe)], style: [.light])
    }
}
