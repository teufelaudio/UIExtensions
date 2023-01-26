// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import SwiftUI

extension GeometryProxy {
    /// Returns the width of the proxy, subtracting the safeAreaInsets.
    public var safeWidth: CGFloat {
        let width: CGFloat = size.width
        let leading: CGFloat = safeAreaInsets.leading
        let trailing: CGFloat = safeAreaInsets.trailing
        return width - leading - trailing
    }
    /// Returns the height of the proxy, subtracting the safeAreaInsets.
    public var safeHeight: CGFloat {
        size.height - safeAreaInsets.top - safeAreaInsets.bottom
    }
}
