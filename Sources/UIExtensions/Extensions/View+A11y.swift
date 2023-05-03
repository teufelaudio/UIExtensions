// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import FoundationExtensions
import SwiftUI

extension View {
    public func accessibilityIdentifier1<I: AccessibilityIdentifiable>(_ identifier: I) -> ModifiedContent<Self, AccessibilityAttachmentModifier> {
        if #available(iOS 14, *) {
            return accessibilityIdentifier(identifier.typePath)
        } else {
            return accessibility(identifier: identifier.typePath)
        }
    }
}

