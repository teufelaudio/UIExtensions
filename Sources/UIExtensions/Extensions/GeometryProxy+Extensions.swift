//
//  GeometryProxy+Extensions.swift
//  UIExtensions
//
//  Created by Luis Reisewitz on 22.01.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

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
