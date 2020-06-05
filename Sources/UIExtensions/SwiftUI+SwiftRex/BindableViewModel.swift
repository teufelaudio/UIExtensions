//
//  BindableViewModel.swift
//  UIExtensions
//
//  Created by Luis Reisewitz on 13.02.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

import CombineRex
import SwiftRex
import SwiftUI

/// Wraps a ViewModel and exposes a subscript that returns Bindings to the `ViewModel`.
public struct BindableViewModel<Action, State> {
    private var viewModel: ObservableViewModel<Action, State>

    public init(_ viewModel: ObservableViewModel<Action, State>) {
        self.viewModel = viewModel
    }

    /// Creates a lens binding to the viewModel, dispatching the action returned by the closure to the store on `set`,
    /// The  returned binding includes a local cache that will return the `set` value until the store updates.
    public subscript<Value>(
        path: KeyPath<State, Value>,
        changeModifier: ChangeModifier = .notAnimated,
        file: String = #file,
        function: String = #function,
        line: UInt = #line,
        info: String? = nil,
        action: ((Value) -> Action?)? = nil) -> Binding<Value> {
            if let actionClosure = action {
                return .store(viewModel,
                              state: path,
                              changeModifier: changeModifier,
                              file: file,
                              function: function,
                              line: line,
                              info: info,
                              onChange: actionClosure)

            } else {
                return .getOnly(viewModel, state: path)
            }
    }
}
