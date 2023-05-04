// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import FoundationExtensions
import SwiftUI

extension View {
    public func accessibilityIdentifier<I: AccessibilityIdentifiable>(_ identifier: I) -> ModifiedContent<Self, AccessibilityAttachmentModifier> {
        if #available(iOS 14, macOS 11, *) {
            return accessibilityIdentifier(identifier.typePath)
        } else {
            return accessibility(identifier: identifier.typePath)
        }
    }
}

