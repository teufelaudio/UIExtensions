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
    @State private var availableSize: CGSize?

    public init<ContentState: Equatable>(
        viewState: ConditionalSizeViewState<ContentState>,
        @ViewBuilder content: @escaping (ContentState, CGSize) -> Content
    ) {
        viewForSize = { size in
            viewState
                .bestOption(for: size)
                .map { bestOption in
                    content(bestOption.contentState, bestOption.size)
                }
        }
    }

    public var body: some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear.preference(key: SizeKey.self, value: proxy.size)
                }
            )
            .onPreferenceChange(SizeKey.self) { size in
                self.availableSize = size
            }
    }

    // This will render twice:
    // - 1st time we don't know the available size yet, so:
    //      - We create a Color.clear, which is greedy and takes all available space.
    //      - The background will follow the main content size and give this size to the Geometry Reader.
    //      - The Geometry Reader will publish SizeKey.self with the available space
    //      - This is reduced by the SizeKey.reducer function, that has initial value of nil, so it accepts
    //        the new value published by the Geometry Reader.
    //      - onPreferenceChange is called due to the SizeKey state reduction, and it updates the local
    //        @State variable availableSize
    //      - @State is a Combine publisher that causes `content` to be re-rendered, so we enter this again
    // - 2nd time we have the available size set, so:
    //      - We return viewForSize, that is the ViewBuilder user provided
    //      - All the steps above will happen again up to the SizeKey.reducer function, which, this time will
    //        realize that value is already set and won't call "nextValue()".
    //      - Because SizeKey.reducer didn't publish a new value, onPreferenceChange won't be triggered again
    //        and the loop will be interrupted. Be careful to not create an infinite loop. :-)
    // Hopefully user won't "see" the empty space caused by the Color.clear version (spoiler: they won't,
    // because everything is supposed to happens in the same UI loop.
    @ViewBuilder
    private var content: some View {
        if let availableSize = self.availableSize {
            viewForSize(availableSize)
        } else {
            // EmptyView or Spacer won't work, we need a greedy View (maxWidth: .infinity, maxHeight: .infinity)
            Color.clear
        }
    }
}

extension View {
    public static func conditionSize<ContentState: Equatable>(
        viewState: ConditionalSizeViewState<ContentState>,
        @ViewBuilder content: @escaping (ContentState, CGSize) -> Self
    ) -> some View {
        ConditionalSizeView(
            viewState: viewState,
            content: content
        )
    }
}

private struct SizeKey: PreferenceKey {
    static func reduce(value: inout CGSize?, nextValue: () -> CGSize?) {
        value = value ?? nextValue()
    }
}
