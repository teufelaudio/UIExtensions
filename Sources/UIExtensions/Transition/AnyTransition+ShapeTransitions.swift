// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Foundation
import SwiftUI

extension AnyTransition {
    public static func rectangular(anchor: AnimationAnchor) -> AnyTransition {
        AnyTransition.modifier(
            active: ShapeClipModifier(shape: RectangularShape(pct: 1, anchor: anchor)),
            identity: ShapeClipModifier(shape: RectangularShape(pct: 0, anchor: anchor))
        )
    }
}
