// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import Foundation
import SwiftUI

public struct DisableAnimationsEnvironmentKey: EnvironmentKey {
    public static let defaultValue: Bool = false
}

extension EnvironmentValues {
    public var disableAnimations: Bool {
        get {
            return self[DisableAnimationsEnvironmentKey.self]
        }
        set {
            self[DisableAnimationsEnvironmentKey.self] = newValue
        }
    }
}
