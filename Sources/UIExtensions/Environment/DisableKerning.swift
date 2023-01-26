// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import SwiftUI

struct DisableKerningEnvironmentKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    public var disableKerning: Bool {
        set { self[DisableKerningEnvironmentKey.self] = newValue }
        get { self[DisableKerningEnvironmentKey.self] }
    }
}

extension View {
    public func disableKerning(_ value: Bool) -> some View {
        environment(\.disableKerning, value)
    }
}
