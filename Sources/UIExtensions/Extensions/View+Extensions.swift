//
//  View+Extensions.swift
//  UIExtensions
//
//  Created by Luiz Barbosa on 01.11.19.
//  Copyright © 2019 Lautsprecher Teufel GmbH. All rights reserved.
//

import SwiftUI

extension View {
    /// Returns an `AnyView` wrapping this view.
    public func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}

// MARK: - Small Helper Extensions
extension View {
    public func squared(length: CGFloat, alignment: Alignment = .center) -> some View {
        frame(width: length, height: length, alignment: alignment)
    }
}

// MARK: - If
extension View {
    @ViewBuilder
    public func `if`<Transform: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Transform) -> some View {
        if (condition()) {
            transform(self)
        } else {
            self
        }
    }
}
