//
//  Toggle+Extensions.swift
//  UIExtensions
//
//  Created by Luiz Barbosa on 01.11.19.
//  Copyright © 2019 Lautsprecher Teufel GmbH. All rights reserved.
//

import CombineRex
import SwiftRex
import SwiftUI

extension Toggle where Label: View {
    public init<Action, State>(viewModel: ObservableViewModel<Action, State>,
                               state: KeyPath<State, Bool>,
                               file: String = #file,
                               function: String = #function,
                               line: UInt = #line,
                               info: String? = nil,
                               onToggle: @escaping (Bool) -> Action,
                               @ViewBuilder content: () -> Label) {
        self.init(isOn: .store(viewModel, state: state, file: file, function: function, line: line, info: info, onChange: onToggle), label: content)
    }
}

extension Toggle where Label == Text {
    public init<Action, State>(
        _ titleKey: LocalizedStringKey,
        viewModel: ObservableViewModel<Action, State>,
        state: KeyPath<State, Bool>,
        file: String = #file,
        function: String = #function,
        line: UInt = #line,
        info: String? = nil,
        onToggle: @escaping (Bool) -> Action) {
        self.init(titleKey, isOn: .store(viewModel, state: state, file: file, function: function, line: line, info: info, onChange: onToggle))
    }

    public init<Action, State, StringType: StringProtocol>(
        _ title: StringType,
        viewModel: ObservableViewModel<Action, State>,
        state: KeyPath<State, Bool>,
        file: String = #file,
        function: String = #function,
        line: UInt = #line,
        info: String? = nil,
        onToggle: @escaping (Bool) -> Action) {
        self.init(title, isOn: .store(viewModel, state: state, file: file, function: function, line: line, info: info, onChange: onToggle))
    }
}
