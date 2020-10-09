//
//  GeometryPreferenceReporter.swift
//  UIExtensions
//
//  Created by Luis Reisewitz on 01.10.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

import SwiftUI

public struct GeometryPreferenceReporter<Key: PreferenceKey>: View {
    private let keyPath: KeyPath<GeometryProxy, Key.Value>

    public init(keyPath: KeyPath<GeometryProxy, Key.Value>) {
        self.keyPath = keyPath
    }

    public var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(Color.clear)
                .preference(key: Key.self, value: geometry[keyPath: self.keyPath])
        }
    }
}
