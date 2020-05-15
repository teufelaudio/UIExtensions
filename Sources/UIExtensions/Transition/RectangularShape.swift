//
//  RectangularShape.swift
//  UIExtensions
//
//  Created by Luiz Rodrigo Martins Barbosa on 29.11.19.
//  Copyright © 2019 Lautsprecher Teufel GmbH. All rights reserved.
//

import Foundation
import SwiftUI

public struct RectangularShape: Shape {
    public var pct: CGFloat
    public let anchor: AnimationAnchor

    public init(pct: CGFloat, anchor: AnimationAnchor) {
        self.pct = pct
        self.anchor = anchor
    }

    public var animatableData: CGFloat {
        get { pct }
        set { pct = newValue }
    }

    public func path(in rect: CGRect) -> Path {
        var path = Path()

        switch anchor {
        case .top:
            path.addRect(.init(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height * pct))
        case .center:
            path.addRect(rect.insetBy(dx: pct * rect.width / 2.0, dy: pct * rect.height / 2.0))
        case .bottom:
            path.addRect(.init(x: rect.minX, y: rect.height - rect.height * pct, width: rect.width, height: rect.height * pct))
        case .left:
            path.addRect(.init(x: rect.minX, y: rect.minY, width: rect.width * pct, height: rect.height))
        case .right:
            path.addRect(.init(x: rect.width - rect.width * pct, y: rect.minY, width: rect.width * pct, height: rect.height))
        }

        return path
    }
}
