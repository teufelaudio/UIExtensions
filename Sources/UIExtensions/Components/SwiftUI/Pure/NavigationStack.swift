// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import SwiftUI

public struct NavigationStack<Content: View>: View {
    private let content: () -> Content

    public init(@ViewBuilder _ content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        if #available(iOS 16, macOS 13, tvOS 16, watchOS 9, *) {
            SwiftUI.NavigationStack {
                content()
            }
        } else {
            // FIXME: If you deeplink more than two level, navigation will stay at the second level.
            // This is a known `NavigationLink` bug.
            NavigationView {
                content()
            }
            #if os(iOS)
            .navigationViewStyle(.stack)
            #endif
        }
    }
}
