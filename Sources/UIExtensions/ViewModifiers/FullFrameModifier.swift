// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import SwiftUI

/// Makes the modified view expand to fill the full offered size.
public struct FullFrameModifier: ViewModifier {
    let excludeSafeAreas: Bool
    let axes: Axis.Set
    let alignment: Alignment

    public func body(content: Content) -> some View {
        GeometryReader { proxy in
            content.frame(width: self.width(for: proxy),
                          height: self.height(for: proxy),
                          alignment: self.alignment)
        }
    }

    private func width(for proxy: GeometryProxy) -> CGFloat? {
        guard axes.contains(.horizontal) else { return nil }
        return excludeSafeAreas ? proxy.safeWidth : proxy.size.width
    }

    private func height(for proxy: GeometryProxy) -> CGFloat? {
        guard axes.contains(.vertical) else { return nil }
        return excludeSafeAreas ? proxy.safeHeight : proxy.size.height
    }
}

// MARK: - Helper Method
extension View {
    /// Makes the modified view expand to fill the full offered size.
    public func fullFrame(excludeSafeAreas: Bool = true,
                          axes: Axis.Set = [.horizontal, .vertical],
                          alignment: Alignment = .center) -> ModifiedContent<Self, FullFrameModifier> {
        modifier(FullFrameModifier(excludeSafeAreas: excludeSafeAreas,
                                   axes: axes,
                                   alignment: alignment))
    }

    public func fullWidth(excludeSafeAreas: Bool = true, alignment: Alignment = .center) -> ModifiedContent<Self, FullFrameModifier> {
        fullFrame(excludeSafeAreas: excludeSafeAreas, axes: .horizontal, alignment: alignment)
    }

    public func fullHeight(excludeSafeAreas: Bool = true, alignment: Alignment = .center) -> ModifiedContent<Self, FullFrameModifier> {
        fullFrame(excludeSafeAreas: excludeSafeAreas, axes: .vertical, alignment: alignment)
    }
}
