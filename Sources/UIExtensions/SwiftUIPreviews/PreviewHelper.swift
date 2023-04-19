// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import SwiftUI

#if DEBUG
public struct PreviewHelper<Content: View>: View {
    private let devices: [String]
    private let content: (String) -> Content
    public static var defaultDevices: [String] {
        [
            "iPhone SE (3rd generation)",
            "iPhone 14 Pro Max",
            "iPad mini (6th generation)",
            "iPad Pro (12.9-inch) (6th generation)"
        ]
    }
    public init(
        _ deviceNames: [String] = defaultDevices,
        @ViewBuilder content: @escaping (String) -> Content
    ) {
        self.devices = deviceNames
        self.content = content
    }

    public init(
        _ deviceNames: [String] = defaultDevices,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.devices = deviceNames
        self.content = { _ in content() }
    }

    public var body: some View {
        ForEach(devices, id: \.self) { device in
            self.content(device)
                .previewDevice(.init(stringLiteral: device))
                .previewDisplayName(device)
        }
    }
}
#endif
