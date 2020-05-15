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

    // TODO: Xcode 11.4 will allow us to use default arguments here.
    // Right now, we need two separate subscripts 🤷‍♀️
    // Besides, actionSource could be split into #file, #function, #line and optional info, so caller don't have to provide it
    /// Creates a lens binding to the viewModel, dispatching the action returned by the closure to the store on `set`,
    /// The  returned binding includes a local cache that will return the `set` value until the store updates.
    public subscript<Value>(path: KeyPath<State, Value>, from actionSource: ActionSource, action: @escaping ((Value) -> Action?)) -> Binding<Value> {
        .store(viewModel,
               state: path,
               file: actionSource.file,
               function: actionSource.function,
               line: actionSource.line,
               info: actionSource.info,
               onChange: action)
    }

    /// Returns a lens binding to the viewModel that can only be used to `get` values. All tries to `set` a
    /// value are ignored, therefore no action is dispatched.
    public subscript<Value>(path: KeyPath<State, Value>) -> Binding<Value> {
        .getOnly(viewModel, state: path)
    }
}
