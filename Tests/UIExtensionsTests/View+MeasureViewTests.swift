// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

#if canImport(UIKit) && canImport(XCTest)
@testable import UIExtensions
import SnapshotTestingExtensions
import SwiftUI
import XCTest

final class ViewMeasureViewTests: SnapshotTestBase {

    struct MeasureMeView: View {
        @State var view1Height: CGFloat = 0
        @State var view2Height: CGFloat = 0
        @State var spacerHeight: CGFloat = 0
        @State var totalHeight: CGFloat = 0

        var body: some View {
            VStack(spacing: 10) {
                Text("View1")
                    .font(.largeTitle)
                .frame(width: 300, height: 123, alignment: .center)
                .border(width: 1, edges: [.leading, .top, .trailing, .bottom], color: .blue)
                .measureView { size in
                    view1Height = size.height
                }

                VStack {
                    Text("View2")
                        .font(.largeTitle)
                        .padding()

                    Spacer()

                    Text("""
                         View1 height: \(view1Height)
                         View2 height: \(view2Height)
                         Spacer height: \(spacerHeight)
                         Total height: \(totalHeight)
                         """)
                        .font(.caption)
                        .padding()
                }
                .frame(width: 300, height: 321, alignment: .center)
                .border(width: 1, edges: [.leading, .top, .trailing, .bottom], color: .green)
                .measureView { size in
                    view2Height = size.height
                }

                Spacer()
                .measureView { size in
                    spacerHeight = size.height
                }
            }
            .background(Color.red.opacity(0.1))
            .measureView { size in
                totalHeight = size.height
            }
        }
    }

    func testMeasureView() {
        let view = MeasureMeView()
        assertSnapshotDevices(view.environment(\.disableAnimations, true), devices: [("SE", .iPhoneSe)], style: [.light])
    }
}
#endif
