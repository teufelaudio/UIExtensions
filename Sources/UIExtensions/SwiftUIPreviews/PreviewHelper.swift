//
//  PreviewHelper.swift
//  UIExtensions
//
//  Created by Luiz Rodrigo Martins Barbosa on 15.04.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

import SwiftUI

#if DEBUG
public struct PreviewHelper<V: View>: View {
    private let view: (String) -> V
    public init(@ViewBuilder view: @escaping (String) -> V) {
        self.view = view
    }

    public var body: some View {
        ForEach(["iPhone SE (1st generation)", "iPhone X", "iPad Pro (12.9-inch) (4th generation)"], id: \.self) { device in
            self.view(device)
                .previewDevice(.init(stringLiteral: device))
                .previewDisplayName(device)
        }
    }
}
#endif
