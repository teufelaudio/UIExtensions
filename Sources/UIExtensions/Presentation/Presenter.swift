//
//  Presenter.swift
//  UIExtensions
//
//  Created by Luis Reisewitz on 07.02.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

import CombineRex
import FoundationExtensions
import SwiftRex

public protocol Presenter {
    associatedtype Event
    associatedtype ViewModel: Emptyable & Equatable

    associatedtype State
    associatedtype Action

    static func handleEvent(event: Event) -> Action?
    static func handleState(state: State) -> ViewModel

    static var emptyViewModel: ViewModel { get }
}

extension Presenter where ViewModel: Emptyable {
    public static var emptyViewModel: ViewModel {
        .empty
    }
}

extension Presenter {
    public static func viewModel<S: StoreType>(store: S) -> ObservableViewModel<Event, ViewModel>
        where S.ActionType == Action, S.StateType == State {
            store.projection(
                action: self.handleEvent,
                state: self.memoizedHandleState()
            ).asObservableViewModel(
                initialState: emptyViewModel,
                emitsValue: .whenDifferent
            )
    }
}

extension Presenter {
    /// Wraps `handleState`. Stores the last "good" result and returns it in case the regular `handleState`
    /// works with invalid state and needs to return `ViewModel.empty`. This helps prevents some
    /// visual glitches, as the screen is not updated with short, intermediate invalid states when going from
    /// one screen/section/flow to the next.
    /// - Returns: A function that can be used with the current state to get a ViewModel.
    static func memoizedHandleState() -> ((State) -> ViewModel) {
        /// Last known good value the Presenter returned.
        var lastValue: ViewModel?
        /// Function that can map `State` to `ViewModel`.
        let presenter = handleState

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
