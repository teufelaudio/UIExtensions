//
//  Picker+Extensions.swift
//  UIExtensions
//
//  Created by Luiz Barbosa on 01.11.19.
//  Copyright © 2019 Lautsprecher Teufel GmbH. All rights reserved.
//

import Combine
import CombineRex
import SwiftRex
import SwiftUI

public protocol PickerOptionProtocol: Hashable {
    associatedtype TagType: Hashable
    var tag: TagType { get }
    var text: String { get }

    init(tag: TagType, value: String)
}

public struct PickerOption<K: Hashable>: PickerOptionProtocol, Hashable {
    public let tag: K
    public let text: String

    public init(tag: K, value: String) {
        self.tag = tag
        self.text = value
    }
}

extension Picker where Label == Text {
    private init<V: View>(
        localizedString: String,
        selection: Binding<SelectionValue>,
        options: [SelectionValue],
        @ViewBuilder content: @escaping (SelectionValue) -> V)
        where Content == ForEach<[SelectionValue], SelectionValue, V> {
        self.init(
            selection: selection,
            // swiftlint:disable:next only_teufeltext
            label: Text(verbatim: localizedString)
        ) {
            ForEach(options, id: \.self) {
                content($0)
            }
        }
    }

    /// Allows to create own views for each option. User is responsible for setting the tag.
    public init<Action, State, V: View>(
        localizedString: String,
        viewModel: ObservableViewModel<Action, State>,
        selectionKeyPath: KeyPath<State, SelectionValue>,
        file: String = #file,
        function: String = #function,
        line: UInt = #line,
        info: String? = nil,
        action: @escaping (SelectionValue.TagType) -> Action,
        options: [SelectionValue],
        @ViewBuilder content: @escaping (SelectionValue) -> V)
        where Content == ForEach<[SelectionValue], SelectionValue, V>,
        SelectionValue: PickerOptionProtocol {

        let binding: Binding<SelectionValue> = .store(
            viewModel,
            state: selectionKeyPath,
            file: file,
            function: function,
            line: line,
            info: info,
            onChange: { (value: SelectionValue) in
                return action(value.tag)
            }
        )
        self.init(
            localizedString: localizedString,
            selection: binding,
            options: options,
            content: content)
    }

    /// Creates simple text views for the picker options.
    public init<Action, State>(
        localizedString: String,
        viewModel: ObservableViewModel<Action, State>,
        selectionKeyPath: KeyPath<State, SelectionValue>,
        file: String = #file,
        function: String = #function,
        line: UInt = #line,
        info: String? = nil,
        action: @escaping (SelectionValue.TagType) -> Action,
        options: [SelectionValue]) where Content == ForEach<[SelectionValue], SelectionValue, AnyView>, SelectionValue: PickerOptionProtocol {
        self.init(
            localizedString: localizedString,
            viewModel: viewModel,
            selectionKeyPath: selectionKeyPath,
            file: file,
            function: function,
            line: line,
            info: info,
            action: action,
            options: options
        ) {
            // swiftlint:disable:next only_teufeltext
            Text($0.text).tag($0.tag).eraseToAnyView()
        }
    }
}
