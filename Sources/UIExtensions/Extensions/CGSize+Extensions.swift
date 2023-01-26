// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import CoreGraphics

extension CGSize {
    /// Returns a `CGSize` with both parts set to `greatestFiniteMagnitude`.
    public static var greatestFiniteMagnitude: CGSize {
        CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
    }
}
