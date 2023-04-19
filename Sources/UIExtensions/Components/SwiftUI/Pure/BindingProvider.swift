// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import SwiftUI

struct BindingProvider<BindedState, Content: View>: View {
    @State private var state: BindedState
    private var content: (_ binding: Binding<BindedState>) -> Content

    init(
        _ initialState: BindedState,
        @ViewBuilder content: @escaping (_ binding: Binding<BindedState>) -> Content
    ) {
        self.content = content
        self._state = State(initialValue: initialState)
    }

    var body: some View {
        content($state)
    }
}
