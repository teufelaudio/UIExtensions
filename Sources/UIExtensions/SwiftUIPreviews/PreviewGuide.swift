// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Foundation
import SwiftUI

#if DEBUG
struct PreviewGuide: ViewModifier {
    private let edge: Edge
    private let color: Color
    private let distance: CGFloat

    private var isRunningInAPreviewCanvas: Bool {
        // From https://stackoverflow.com/a/61741858 - env is "1" when running in a canvas.
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }

    public init(edge: Edge, color: Color, distance: CGFloat) {
        self.edge = edge
        self.color = color
        self.distance = distance
    }

    public func body(content: Content) -> some View {
        if #available(iOS 15.0, *), isRunningInAPreviewCanvas {
            content
                .background {
                    guide()
                    .ignoresSafeArea()
                }
        } else {
            content
        }
    }

    @ViewBuilder
    private func guide() -> some View {
        switch edge {
        case .top:
            fromTop()
        case .bottom:
            fromBottom()
        case .leading:
            fromLeading()
        case .trailing:
            fromTrailing()
        }
    }

    private func fromBottom() -> some View {
        VStack {
            Spacer()
            color
                .frame(height: 1.0)
            Color.clear
                .frame(height: distance)
        }
    }

    private func fromTop() -> some View {
        VStack {
            Color.clear
                .frame(height: distance)
            color
                .frame(height: 1.0)
            Spacer()
        }
    }

    private func fromLeading() -> some View {
        HStack {
            Color.clear
                .frame(width: distance)
            color
                .frame(width: 1.0)
            Spacer()
        }
    }

    private func fromTrailing() -> some View {
        HStack {
            Spacer()
            color
                .frame(width: 1.0)
            Color.clear
                .frame(width: distance)
        }
    }
}

extension View {
    /// Adds a guide line to the view. The guide line is only visible in the preview, neither in snapshot tests nor in production.
    ///
    /// Example usage:
    /// ```
    /// VStack {
    ///     Spacer()
    ///     Text("OHAI")
    /// }
    /// .previewGuide(.bottom, 48)
    /// ```
    ///
    /// - Parameters:
    ///   - edge: reference Edge, from where the distance should be used
    ///   - distance: distance from the given edge of the view
    public func previewGuide(_ edge: Edge, color: Color, distance: CGFloat) -> some View {
        self.modifier(PreviewGuide(edge: edge, color: color, distance: distance))
    }
}

#endif
