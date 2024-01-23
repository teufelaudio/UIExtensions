// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import SwiftUI

#if os(iOS)
struct ShakeGestureViewModifier: ViewModifier {
  let action: () -> Void
  
  func body(content: Content) -> some View {
    content.onReceive(NotificationCenter.default.publisher(for: .didShakeDevice)) { _ in
        action()
    }
  }
}

extension View {
  public func onShakeGesture(perform action: @escaping () -> Void) -> some View {
    self.modifier(ShakeGestureViewModifier(action: action))
  }
}
#endif
