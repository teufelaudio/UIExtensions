// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import FoundationExtensions
import SwiftUI

extension View {
    @ViewBuilder
    public func accessibilityIdentifier<I: AccessibilityIdentifiable>(_ identifier: I) -> some View {
        if #available(iOS 14, *) {
           accessibilityIdentifier(identifier.typePath)
        } else {
           accessibility(identifier: identifier.typePath)
        }
    }
}
