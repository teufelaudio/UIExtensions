// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Foundation
import SwiftUI

extension Spacer {
    public static func between(_ range: ClosedRange<CGFloat>,
                               ideal: CGFloat? = nil,
                               limitVertically: Bool = true,
                               limitHorizontally: Bool = true) -> some View {
        Spacer(minLength: range.lowerBound)
            .frame(
                idealWidth: limitHorizontally ? ideal : nil,
                maxWidth: limitHorizontally ? range.upperBound: nil,
                idealHeight: limitVertically ? ideal : nil,
                maxHeight: limitVertically ? range.upperBound : nil
            )
    }

    public static func exactWidth(_ value: CGFloat) -> some View {
        Spacer(minLength: value).frame(width: value, height: 1)
    }

    public static func exactHeight(_ value: CGFloat) -> some View {
        Spacer(minLength: value).frame(width: 1, height: value)
    }

    public static func multiple(_ multipler: Int, minLength: CGFloat? = nil) -> some View {
        MultipleSpacer(multiplier: multipler, minLength: minLength)
    }
}
