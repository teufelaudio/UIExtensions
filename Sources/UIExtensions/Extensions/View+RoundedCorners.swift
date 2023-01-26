// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

#if canImport(UIKit)
import SwiftUI
import UIKit

extension View {
    public func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorners(radius: radius, corners: corners) )
    }
}

private struct RoundedCorners: Shape {
    var radius: CGFloat = CGFloat.infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
#endif
