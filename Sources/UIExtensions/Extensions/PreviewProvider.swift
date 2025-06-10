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

    @ViewBuilder
    public static func withUnwrapping<A, Content: View>(
        _ a: A?,
        @ViewBuilder content: @escaping (A) -> Content
    ) -> some View {
        if let a {
            content(a)
        } else {
            UnwrappingDebugView(failedIndices: [0], totalCount: 1)
        }
    }

    @ViewBuilder
    public static func withUnwrapping<A, B, Content: View>(
        _ a: A?, _ b: B?,
        @ViewBuilder content: @escaping (A, B) -> Content
    ) -> some View {
        if let a, let b {
            content(a, b)
        } else {
            let failed = [a == nil ? 0 : nil, b == nil ? 1 : nil].compactMap { $0 }
            UnwrappingDebugView(failedIndices: failed, totalCount: 2)
        }
    }

    @ViewBuilder
    public static func withUnwrapping<A, B, C, Content: View>(
        _ a: A?, _ b: B?, _ c: C?,
        @ViewBuilder content: @escaping (A, B, C) -> Content
    ) -> some View {
        if let a, let b, let c {
            content(a, b, c)
        } else {
            let failed = [a == nil ? 0 : nil, b == nil ? 1 : nil, c == nil ? 2 : nil].compactMap { $0 }
            UnwrappingDebugView(failedIndices: failed, totalCount: 3)
        }
    }
}

private struct UnwrappingDebugView: View {
    let failedIndices: [Int]
    let totalCount: Int

    var body: some View {
        VStack {
            Text("⚠️ Missing Parameters")
                .font(.headline)
                .foregroundColor(.red)

            Text("Indexes: \(failedIndices.map { "\($0)" }.joined(separator: ", "))")
                .font(.caption)
                .foregroundColor(.orange)
        }
        .padding()
        .background(Color.yellow.opacity(0.2))
        .cornerRadius(8)
    }
}
#endif
