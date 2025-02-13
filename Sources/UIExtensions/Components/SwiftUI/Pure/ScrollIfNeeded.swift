// Copyright © 2024 Lautsprecher Teufel GmbH. All rights reserved.

import SwiftUI

@available(*, deprecated, message: "ScrollIfNeeded is about to be removed entirely, please use ScrollView and .scrollBounceBehavior(.basedOnSize) instead.")
@available(iOS 16.4, *)
/// A view that embeds content in a scroll view if content overflows.
public struct ScrollIfNeeded<Content: View>: View {
    private let content: () -> Content
    private let axis: Axis.Set

    /// Initializes a new instance of `ScrollIfNeeded`.
    ///
    /// - Parameters:
    ///   - axis: The axis along which scrolling should occur. Defaults to vertical.
    ///   - content: A closure returning the content to embed within the scroll view.
    public init(
        in axis: Axis.Set = [.vertical],
        @ViewBuilder
        content: @escaping () -> Content
    ) {
        self.axis = axis
        self.content = content
    }

    public var body: some View {
        ScrollView(axis, content: content)
            .scrollBounceBehavior(.basedOnSize)
    }
}
