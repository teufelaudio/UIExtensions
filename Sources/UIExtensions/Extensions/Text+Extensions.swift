// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

#if canImport(SwiftUI)
import SwiftUI
extension Text {
    /**
    The extension provides a way to apply a linear gradient as the foreground of a text view. This is useful for creating visually interesting text with gradients.

    To use this extension, call the `foregroundLinearGradient(colors:startPoint:endPoint:)` method on any Text view instance. Pass in an array of `Color` values to be used in the gradient, as well as the start and end points of the gradient, specified as `UnitPoint` values.

    Example Usage:

        Text("Hello, World!")
            .font(.title)
            .foregroundColor(.white)
            .foregroundLinearGradient(
                colors: [.red, .yellow],
                startPoint: .leading,
                endPoint: .trailing
            )

     This will apply a linear gradient from red to yellow as the foreground of the "Hello, World!" text. The gradient will start at the leading edge of the text and end at the trailing edge.

     - Parameters:
       - colors: An array of colors to be used in the gradient.
       - startPoint: The point at which the gradient begins. The point is specified as a unit coordinate space.
       - endPoint: The point at which the gradient ends. The point is specified as a unit coordinate space.
     - Returns: A view with a linear gradient as its foreground.
     */
    public func foregroundLinearGradient(
        _ colors: [Color],
        startPoint: UnitPoint,
        endPoint: UnitPoint
    ) -> some View {
        self.overlay(
            LinearGradient(
                colors: colors,
                startPoint: startPoint,
                endPoint: endPoint
            )
            .mask(self)
        )
    }
}
#endif
