//  Copyright © 2021 Lautsprecher Teufel GmbH. All rights reserved.

import SwiftUI

/// A view that will be created out of a variable View State, that will be picked according to the parent frame
/// (available dimensions of this View).
/// This can be useful, for example, to pick the best image quality out of a list of options, when resizing is not
/// desired.
/// It provides a list of diferent View States that will differ according to the available size given by the parent
/// The best option for View State will be anything that fits in the parent's frame, and also enforcing aspect is
/// available in case only horizontal views are allowed in horizontal parents, and only vertical views are allowed
/// in vertical parents.
/// Otherwise, anything that fits both dimensions - regardles of aspect - will be chosen, having priority those with
/// more pixels and less priority those with fewer pixels. If pixel count is the same, aspect decides. Hashable ensure
/// that you can't have 2 options with exact same height and width.
public struct ConditionalSizeView<Content: View>: View {
    public let viewForSize: (CGSize) -> Content?

    public init<ContentState: Equatable>(
        viewState: ConditionalSizeViewState<ContentState>,
        @ViewBuilder content: @escaping (ContentState) -> Content
    ) {
        viewForSize = { size in
            viewState
                .bestOption(for: size)
                .map { bestOption in
                    content(bestOption.contentState)
                }
        }
    }

    public var body: some View {
        GeometryReader { proxy in
            viewForSize(proxy.size)
        }
    }
}

extension View {
    public static func conditionSize<ContentState: Equatable>(
        viewState: ConditionalSizeViewState<ContentState>,
        @ViewBuilder content: @escaping (ContentState) -> Self
    ) -> some View {
        ConditionalSizeView(
            viewState: viewState,
            content: content
        )
    }
}
