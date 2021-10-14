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

    /// Dumps the content (using `Swift.dump()` of `t` when evaluating this View.
    /// Especially useful for monitoring animated values during transitions.
    ///
    /// - Parameter t: Value to dump. Can be a variable, or a binding, or anything.
    /// - Returns: The unmodified receiving view.
    public func dump<T>(_ t: @autoclosure () -> T) -> Self {
        Swift.dump(t())
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

// MARK: - Conditional hidden
extension View {
    /// Conditionally applies the hidden modifier to the receiving view, or leaves it unchanged.
    /// - Parameters:
    ///   - shouldHide: Condition to evaluate. If shouldHide evaluates to `false`,  the view is returned.
    /// - Returns: The same view, either hidden or not.
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true:
            self.hidden()
        case false:
            self
        }
    }
}
