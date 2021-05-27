// Copyright © 2021 Lautsprecher Teufel GmbH. All rights reserved.

import SwiftUI

public struct CircledNumber<Content: View, S: ShapeStyle>: View {
    private let length: CGFloat
    private let content: Content
    private let strokeContent: S

    public init(number: Int, length: CGFloat, strokeContent: S, @ViewBuilder content: @escaping (Int) -> Content) {
        self.content = content(number)
        self.length = length
        self.strokeContent = strokeContent
    }
    public var body: some View {
        content
            .squared(length: length)
            .background(Circle().stroke(strokeContent), alignment: .center)
    }
}

#if DEBUG
struct CircledNumberPreviews: PreviewProvider {
    static var previews: some View {
        CircledNumber(number: 9, length: 18) { Text("\($0)") }
    }
}
#endif
