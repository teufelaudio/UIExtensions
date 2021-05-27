//
//  InfiniteFrameModifier.swift
//  UIExtensions
//
//  Created by Luis Reisewitz on 26.03.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

import SwiftUI

public struct InfiniteFrameModifier: ViewModifier {
    let axes: Axis.Set
    let alignment: Alignment

    public func body(content: Content) -> some View {
        content.frame(maxWidth: maxWidth,
                      maxHeight: maxHeight,
                      alignment: alignment)
    }

    private var maxWidth: CGFloat? {
        value(for: .horizontal)
    }

    private var maxHeight: CGFloat? {
        value(for: .vertical)
    }

    private func value(for axis: Axis.Set) -> CGFloat? {
        axes.contains(axis) ? CGFloat.infinity : nil
    }
}

// MARK: - Helper Method
extension View {
    // We are choosing default alignment of .center here, as this is also the
    // default alignment for the `frame` view modifier.

    /// Makes the modified view expand to fill the full offered size.
    public func infiniteFrame(axes: Axis.Set = [.horizontal, .vertical],
                              alignment: Alignment = .center) -> ModifiedContent<Self, InfiniteFrameModifier> {
        modifier(InfiniteFrameModifier(axes: axes, alignment: alignment))
    }

    public func infiniteWidth(alignment: Alignment = .center) -> ModifiedContent<Self, InfiniteFrameModifier> {
        infiniteFrame(axes: .horizontal, alignment: alignment)
    }

    public func infiniteHeight(alignment: Alignment = .center) -> ModifiedContent<Self, InfiniteFrameModifier> {
        infiniteFrame(axes: .vertical, alignment: alignment)
    }
}
