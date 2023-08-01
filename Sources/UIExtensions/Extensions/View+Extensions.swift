// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

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

// MARK: - SquaredBorder
extension View {
    /**
     The extension adds a squared border to a view and displays the provided `CustomText` view on each side of the border.
     This is useful for displaying annotations or labels for the content inside the border.

     To use this extension, call the `border(_:dividerColor:dividerWidth:)` method on any `View` instance.
     Pass in a closure that returns a `CustomText` view to be displayed on each side

     - Parameters:
       - text: A closure that returns a `CustomText` view to be displayed on each side of the border.
       - dividerColor: The color of the border. Default value is `.red`.
       - dividerWidth: The width of the border. Default value is `0.4`.
     */
    public func border<CustomText: View>(
        @ViewBuilder
        _ text: @escaping () -> CustomText,
        dividerColor: Color = .red,
        dividerWidth: CGFloat = 0.4
    ) -> some View {
        modifier(SquaredBorderTextViewModifier(
            text,
            dividerColor: dividerColor,
            dividerWidth: dividerWidth)
        )
    }
}

private struct SquaredBorderTextViewModifier<CustomText: View>: ViewModifier {
    @State
    private var contentSize: CGSize = .zero
    @State
    private var textSize: CGSize = .zero
    @ViewBuilder
    private let text: () -> CustomText
    private let dividerColor: Color
    private let dividerWidth: CGFloat

    init(
        @ViewBuilder _ text: @escaping () -> CustomText,
        dividerColor: Color,
        dividerWidth: CGFloat
    ) {
        self.text = text
        self.dividerColor = dividerColor
        self.dividerWidth = dividerWidth
    }

    func body(content: Content) -> some View {
        HStack(spacing: .zero) {
            text()
                .frame(width: contentSize.height)
                .rotationEffect(.degrees(270))
                .frame(width: textSize.height, height: contentSize.height)
            VStack(spacing: .zero) {
                text()
                    .measureView { textSize = $0 }
                    .frame(width: contentSize.width)
                content
                    .measureView { contentSize = $0 }
                    .padding(dividerWidth)
                    .border(dividerColor, width: dividerWidth)
                text()
                    .frame(width: contentSize.width)
                    .rotationEffect(.degrees(180))
            }
            text()
                .frame(width: contentSize.height)
                .rotationEffect(.degrees(90))
                .frame(width: textSize.height, height: contentSize.height)
        }
        .padding(dividerWidth)
        .border(dividerColor, width: dividerWidth)
    }
}
