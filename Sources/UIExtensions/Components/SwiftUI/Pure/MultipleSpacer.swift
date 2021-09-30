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
    private let minLength: CGFloat?

    public init(multiplier: Int, minLength: CGFloat? = nil) {
        self.multiplier = multiplier
        self.minLength = minLength
    }

    public var body: some View {
        Group {
            if multiplier > 0 {
                ForEach(1...multiplier, id: \.self) { _ in
                    Spacer.init(minLength: minLength)
                }
            }
        }
    }
}
