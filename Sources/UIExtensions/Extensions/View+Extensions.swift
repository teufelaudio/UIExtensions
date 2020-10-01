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

    public func dump<T>(_ t: T) -> Self {
        Swift.dump(t)
        return self
    }
}

// MARK: - If
extension View {
    /// Conditionally applies a transformation to the receiving view.
    /// - Parameters:
    ///   - condition: Condition to evaluate. It's evaluated lazily. If condition evaluates to `true`, `transform` is applied.
    ///   - transform: Transformation to apply to the `View`. This can be used ot apply ViewModifiers or similar.
    /// - Returns: The same view, either unchanged or with transformation applied.
    ///
    /// Inspiration taken from <https://fivestars.blog/swiftui/conditional-modifiers.html>
    @ViewBuilder
    public func `if`<Transform: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Transform) -> some View {
        if (condition()) {
            transform(self)
        } else {
            self
        }
    }
}

// MARK: - If Let
extension View {
    /// Conditionally applies a transformation to the receiving view.
    /// - Parameters:
    ///   - condition: Condition to evaluate. It's evaluated lazily. If condition evaluates to `true`, `transform` is applied.
    ///   - transform: Transformation to apply to the `View`. This can be used ot apply ViewModifiers or similar.
    /// - Returns: The same view, either unchanged or with transformation applied.
    ///
    /// Inspiration taken from <https://fivestars.blog/swiftui/conditional-modifiers.html>
    @ViewBuilder
    public func `ifLet`<Transform: View, T>(_ optional: @autoclosure () -> T?, transform: (Self, T) -> Transform) -> some View {
        if let value = optional() {
            transform(self, value)
        } else {
            self
        }
    }
}
