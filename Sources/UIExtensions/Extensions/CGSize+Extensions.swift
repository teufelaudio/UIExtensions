//
//  CGSize+Extensions.swift
//  UIExtensions
//
//  Created by Luis Reisewitz on 22.06.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

import CoreGraphics

extension CGSize {
    /// Returns a `CGSize`with both parts set to `greatestFiniteMagnitude`.
    public static var greatestFiniteMagnitude: CGSize {
        .init(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
    }
}
