//
//  PresenterWithInput.swift
//  TeufelBluetooth
//
//  Created by Luis Reisewitz on 07.02.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

import CombineRex
import FoundationExtensions
import SwiftRex

public protocol PresenterWithInput {
    associatedtype Event
    associatedtype ViewModel: Emptyable & Equatable
    associatedtype Input

    associatedtype State
    associatedtype Action

    static func handleEvent(input: Input) -> ((Event) -> Action?)
    static func handleState(input: Input) -> ((State) -> ViewModel)

    static var emptyViewModel: ViewModel { get }
}

extension PresenterWithInput where ViewModel: Emptyable {
    public static var emptyViewModel: ViewModel {
        .empty
    }
}

extension PresenterWithInput {
    public static func viewModel<S: StoreType>(input: Input, store: S) -> ObservableViewModel<Event, ViewModel>
        where S.ActionType == Action, S.StateType == State {
            store.projection(
                action: self.handleEvent(input: input),
                state: self.memoizedHandleState(input: input)
            )
                .asObservableViewModel(
                    initialState: emptyViewModel,
                    emitsValue: .whenDifferent
            )
    }
}

// MARK: - Memoization
extension PresenterWithInput {
    /// Wraps `handleState`. Stores the last "good" result and returns it in case the regular `handleState`
    /// works with invalid state and needs to return `ViewModel.empty`. This helps prevents some
    /// visual glitches, as the screen is not updated with short, intermediate invalid states when going from
    /// one screen/section/flow to the next.
    /// - Parameter input: Same Input as to the regular `handleState`.
    /// - Returns: A function that can be used with the current state to get a ViewModel.
    static func memoizedHandleState(input: Input) -> ((State) -> ViewModel) {
        /// Last known good value the Presenter returned.
        var lastValue: ViewModel?
        /// Function that can map `State` to `ViewModel`.
        let presenter = handleState(input: input)

        return { state in
            // First, check what the regular presenter would do.
            let viewModel = presenter(state)

            if viewModel == .empty {
                guard let lastValue = lastValue else {
                    // This is a weird case. Sometimes, this is totally fine,
                    // e.g. LaunchViewModel has no children, therefore is always
                    // empty. If we could separate these cases, I would
                    // `assertionFailure` here, but as this is triggered quite
                    // often, and a lot of times legitimately, this is not possible.
                    // We could however think about recording this to Crashlytics though.
                    return viewModel
                }
                return lastValue
            } else {
                // Current ViewModel is not empty, everything is good.
                // Store this as the "last known good value" for the next time
                // and return.
                lastValue = viewModel
                return viewModel
            }
        }
    }
}
