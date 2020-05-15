//
//  ObservableViewModel+BindableViewModel.swift
//  UIExtensions
//
//  Created by Luis Reisewitz on 13.02.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

import CombineRex

extension ObservableViewModel {
    /// Creates a `Binding` lens for the `ViewModel`. All keypaths of the state are supported and
    /// can be exposed as a `Binding`.
    public var binding: BindableViewModel<ActionType, StateType> {
        BindableViewModel(self)
    }
}
