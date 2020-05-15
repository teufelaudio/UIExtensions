//
//  UIRectCorner+Extensions.swift
//  UIExtensions
//
//  Created by Luis Reisewitz on 16.01.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

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
