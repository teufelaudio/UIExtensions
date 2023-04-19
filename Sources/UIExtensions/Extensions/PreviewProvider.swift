// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import SwiftUI

#if DEBUG
extension PreviewProvider {
    @ViewBuilder
    public static func withBinding<BindedState, Content: View>(
        _ initialState: BindedState,
        @ViewBuilder content: @escaping (_ binding: Binding<BindedState>) -> Content
    ) -> some View {
        BindingProvider(initialState, content: content)
    }

    @ViewBuilder
    public static func withPreviewDevices<Content: View>(
        _ deviceNames: [String]? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        if let deviceNames { PreviewHelper(deviceNames, content: content) }
        else { PreviewHelper(content: content) }
    }

    @ViewBuilder
    public static func withPreviewDevices<Content: View>(
        _ deviceNames: [String]? = nil,
        @ViewBuilder content: @escaping (String) -> Content
    ) -> some View {
        if let deviceNames { PreviewHelper(deviceNames, content: content) }
        else { PreviewHelper(content: content) }
    }
}
#endif
