//
//  MultipleSpacer.swift
//  UIExtensions
//
//  Created by Luiz Rodrigo Martins Barbosa on 15.04.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

import SwiftUI

public struct MultipleSpacer: View {
    private let multiplier: Int

    public init(multiplier: Int) {
        self.multiplier = multiplier
    }

    public var body: some View {
        Group {
            if multiplier > 0 {
                ForEach(1...multiplier, id: \.self) { _ in
                    Spacer()
                }
            }
        }
    }
}
