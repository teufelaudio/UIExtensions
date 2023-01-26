// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import SwiftUI

#if os(iOS)
public struct HorizontalSizeClassView<CompactView: View, RegularView: View>: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    private let compact: () -> CompactView
    private let regular: () -> RegularView

    public init(@ViewBuilder compact: @escaping () -> CompactView, @ViewBuilder regular: @escaping () -> RegularView) {
        self.compact = compact
        self.regular = regular
    }

    public var body: some View {
        ViewBuilder.buildBlock(
            horizontalSizeClass == .compact ?
                ViewBuilder.buildEither(first: compact()) :
                ViewBuilder.buildEither(second: regular())
        )
    }
}
#endif
