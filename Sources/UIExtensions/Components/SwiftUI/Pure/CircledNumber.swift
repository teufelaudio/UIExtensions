// Copyright © 2021 Lautsprecher Teufel GmbH. All rights reserved.

import SwiftUI

public struct CircledNumber: View {
    private let number: Int

    public init(number: Int) {
        self.number = number
    }

    public var body: some View {
        TeufelText("\(number)")
            .teufelTextStyle(.footnoteRegularPrimary)
            .squared(length: 18)
            .background(Circle().stroke(Color.black), alignment: .center)
    }
}

#if DEBUG
struct CircledNumberPreviews: PreviewProvider {
    static var previews: some View {
        CircledNumber(number: 9)
    }
}
#endif
