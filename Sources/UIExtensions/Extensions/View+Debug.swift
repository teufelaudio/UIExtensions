// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

// The following additions are only to be used in Debug mode.
#if DEBUG && canImport(SwiftUI)
import SwiftUI

extension View {
    /// Allows to execute a function whenever this view is rendered. This is a useful helper for debugging
    /// View state when rendering. Can be used to e.g. print something whenever this view is re-created
    /// (the body is accessed).
    ///
    /// Usage:
    ///
    ///     .debug {
    ///         print("Print something whenever view is rendered")
    ///     }
    ///
    /// - Parameter closure: Closure to execute whenever this view hierarchy is created.
    /// - Returns: The same view this was called, chainable.
    public func debug(_ closure: () -> Void) -> Self {
        closure()
        return self
    }
}
#endif
