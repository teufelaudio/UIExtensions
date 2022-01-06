// Copyright © 2022 Lautsprecher Teufel GmbH. All rights reserved.

import SwiftUI

extension View {

    /// Add's a horizontally fade in/out effect to the view. The padding allows to start the fade effect relative to the horizontal bounds of the view.
    public func maskHorizontally(leftPadding: CGFloat = 0, leftFade: CGFloat? = nil, rightFade: CGFloat? = nil, rightPadding: CGFloat = 0) -> some View {
        self.mask(horizontalMask(leftPadding: leftPadding, leftFade: leftFade, rightFade: rightFade, rightPadding: rightPadding))
    }

    private func horizontalMask(leftPadding: CGFloat, leftFade: CGFloat? = nil, rightFade: CGFloat? = nil, rightPadding: CGFloat) -> some View {
        HStack(spacing: 0) {
            Rectangle()
                    .frame(width: leftPadding)
                    .opacity(0)

            leftFade.map {
                LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0), Color.black]),
                        startPoint: .leading,
                        endPoint: .trailing)
                        .frame(width: $0)
            }

            LinearGradient(gradient: Gradient(colors: [Color.black, Color.black]),
                    startPoint: .leading,
                    endPoint: .trailing)

            rightFade.map {
                LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0), Color.black]),
                        startPoint: .trailing,
                        endPoint: .leading)
                        .frame(width: $0)
            }

            Rectangle()
                    .frame(width: rightPadding)
                    .opacity(0)
        }
    }
}
