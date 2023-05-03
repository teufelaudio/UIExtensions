// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import FoundationExtensions
import SwiftUI

extension View {
    public func accessibilityIdentifier<I: AccessibilityIdentifiable>(_ identifier: I) -> ModifiedContent<Self, AccessibilityAttachmentModifier> {
        self.accessibilityIdentifier(identifier.typePath)
    }
}
