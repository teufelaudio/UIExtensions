//
//  Binding+Debug.swift
//  UIExtensions
//
//  Created by Luis Reisewitz on 11.12.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

// The following additions are only to be used in Debug mode.
#if DEBUG && canImport(SwiftUI)
import SwiftUI

extension Binding {
    /// Returns a binding that allows to execute closures whenever the receiving binding is accessed.
    /// Allows to print a message when the value is accessed and whenever a new value is set.
    ///
    /// Usage:
    ///
    ///     let newBinding = myBinding.debug { currentValue in
    ///         print("Binding.get called. Current value: \(currentValue)")
    ///     } onSet: { oldValue, newValue in
    ///         print("Binding.set called. Old value: \(oldValue). New value: \(newValue)")
    ///     }
    ///
    /// - Parameters:
    ///   - onGet: Closure to execute whenever the value is accessed. This closure is passed the current
    ///   value of the binding before it's returned to the caller.
    ///   - onSet: Closure to execute whenever the value is changed. This closure is passed the old
    ///   value and the new value respectively before the value is changed.
    /// - Returns: Binding with same types, can be chained.
    public func debug(onGet: ((Value) -> Void)? = nil,
                      onSet: ((Value, Value) -> Void)? = nil)
    -> Self {
        .init {
            let currentValue = self.wrappedValue
            onGet?(currentValue)
            return currentValue
        } set: { newValue in
            let oldValue = self.wrappedValue
            onSet?(oldValue, newValue)
            self.wrappedValue = newValue
        }
    }
}
#endif
