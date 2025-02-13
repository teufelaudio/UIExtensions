// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import SwiftUI

public struct CircledNumber<Content: View, S: ShapeStyle>: View {
    private let length: CGFloat
    private let content: Content
    private let strokeContent: S
    private let backgroundColor: Color

    public init(number: Int, length: CGFloat, strokeContent: S, backgroundColor: Color = Color.clear, @ViewBuilder content: @escaping (Int) -> Content) {
        self.content = content(number)
        self.length = length
        self.strokeContent = strokeContent
        self.backgroundColor = backgroundColor
    }
    public var body: some View {
        content
            .frame(width: length, height: length, alignment: .center)
            .background(
                Circle().strokeBorder(style: .init(lineWidth: 1)),
                alignment: .center
            )
            .background(Circle().fill(backgroundColor))
    }
}

#if DEBUG
struct CircledNumberPreviews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            CircledNumber(number: 9, length: 18, strokeContent: Color.black, backgroundColor: Color.red) { Text("\($0)") }

            CircledNumber(number: 9, length: 18, strokeContent: Color.red) { Text("\($0)") }
        }
    }
}
#endif
