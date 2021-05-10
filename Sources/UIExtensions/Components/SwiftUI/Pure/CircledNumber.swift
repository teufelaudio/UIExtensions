// Copyright © 2021 Lautsprecher Teufel GmbH. All rights reserved.

import SwiftUI

public struct CircledNumber<Content: View>: View {
    private let length: CGFloat
    private let content: Content

    public init(number: Int, length: CGFloat, @ViewBuilder content: @escaping (Int) -> Content) {
        self.content = content(number)
        self.length = length
    }
    public var body: some View {
        content
            .squared(length: length)
            .background(Circle().stroke(Color.black), alignment: .center)
    }
}

#if DEBUG
struct CircledNumberPreviews: PreviewProvider {
    static var previews: some View {
        CircledNumber(number: 9, length: 18) { Text("\($0)") }
    }
}
#endif
