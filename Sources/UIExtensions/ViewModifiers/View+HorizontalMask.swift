// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import SwiftUI

extension View {

    /// Adds a horizontally fade in/out effect to the view. The padding allows to start the fade effect relative to the horizontal bounds of the view.
    /// ```
    ///  ◀─leadingPadding─▶ ◀─leadingFade─▶ ◀──[expands]──▶ ◀─trailingFade─▶ ◀─trailingPadding─▶
    /// ┌──────────────────┬───────────────┬───────────────┬────────────────┬──────────────────┐
    /// │                  │               │               │                │                  │
    /// │        _         │       ◢       │      ███      │       ◣        │        _         │
    /// │                  │               │               │                │                  │
    /// └──────────────────┴───────────────┴───────────────┴────────────────┴──────────────────┘
    /// ```
    public func maskHorizontally(leadingPadding: CGFloat = 0, leadingFade: CGFloat = 0, trailingFade: CGFloat = 0, trailingPadding: CGFloat = 0) -> some View {
        self.mask(
            HStack(spacing: 0) {
                LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0), Color.black]),
                               startPoint: .leading,
                               endPoint: .trailing)
                    .frame(width: leadingFade)

                Color.black

                LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0), Color.black]),
                               startPoint: .trailing,
                               endPoint: .leading)
                    .frame(width: trailingFade)
            }
            .padding(.leading, leadingPadding)
            .padding(.trailing, trailingPadding)
        )
    }
}
