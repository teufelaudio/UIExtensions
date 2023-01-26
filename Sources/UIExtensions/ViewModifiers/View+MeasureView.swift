// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import SwiftUI

struct ViewSizeKey: PreferenceKey {
    static let defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

extension View {

    /// Measures the view dimensions.
    public func measureView(_ result: @escaping (CGSize) -> Void) -> some View {
        overlay(GeometryReader { proxy in
            Color.clear.preference(key: ViewSizeKey.self, value: proxy.size)
        }
        .onPreferenceChange(ViewSizeKey.self, perform: result))
    }
}
