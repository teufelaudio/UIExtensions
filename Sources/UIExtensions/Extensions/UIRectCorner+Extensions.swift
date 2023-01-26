// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

#if canImport(UIKit)
import UIKit

extension UIRectCorner {
    public static var top: Self {
        [.topLeft, .topRight]
    }

    public static var bottom: Self {
        [.bottomLeft, .bottomRight]
    }
}
#endif
