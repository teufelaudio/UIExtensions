// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Foundation
import SwiftUI

public struct ShapeClipModifier<S: Shape>: ViewModifier {
    public let shape: S

    public init(shape: S) {
        self.shape = shape
    }

    public func body(content: Content) -> some View {
        content.clipShape(shape)
    }
}
