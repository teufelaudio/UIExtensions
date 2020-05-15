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
        size.width - safeAreaInsets.leading - safeAreaInsets.trailing
    }
    /// Returns the height of the proxy, subtracting the safeAreaInsets.
    public var safeHeight: CGFloat {
        size.height - safeAreaInsets.top - safeAreaInsets.bottom
    }
}
