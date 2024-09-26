// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import SwiftUI

extension Binding {
    /// Transforms a `Binding<Value>` in a `Binding<Optional<Value>>`. This is useful when your
    /// internal binding allows optional values to be read and set, but your parent control only
    /// offers binding to a non-Optional type.
    ///
    /// You can optionally provide a closure to be called when the inner component sets the wrapped
    /// value no nil, so your parent control can act on that accordingly.
    public func toOptional(onSetToNil: @escaping @Sendable () -> Void = { }) -> Binding<Value?> where Value: Sendable {
        Binding<Value?>(
            get: { self.wrappedValue },
            set: { newValue in
                guard let newValue = newValue else {
                    onSetToNil()
                    return
                }
                self.wrappedValue = newValue
            }
        )
    }
}

extension Binding {
    /// Transforms a `Binding<Optional<Value>>` in a `Binding<Value>`. This is useful when your
    /// internal binding requires a non-nil value, but your parent control only offers binding
    /// to an Optional type. You must provide a default fallback for when reading a nil value.
    public func toNonOptional<V: Sendable>(default fallback: V) -> Binding<V> where Value == V? {
        Binding<V>(
            get: { self.wrappedValue ?? fallback },
            set: { self.wrappedValue = $0 }
        )
    }
}

