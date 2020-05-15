//
//  ShapeClipModifier.swift
//  UIExtensions
//
//  Created by Luiz Rodrigo Martins Barbosa on 29.11.19.
//  Copyright © 2019 Lautsprecher Teufel GmbH. All rights reserved.
//

import Foundation
import SwiftUI

public struct ShapeClipModifier<S: Shape>: ViewModifier {
    public let shape: S

    public init(shape: S) {
        self.shape = shape
    }

    public func body(content: Content) -> some View {
        content.clipShape(shape)
    }
}
