// Copyright © 2024 Lautsprecher Teufel GmbH. All rights reserved.

import SwiftUI

/// Enumerated list of Strings such as for instructions or help usage. Enumeration is
/// shown as `CircledNumber`.
struct EnumeratedList<TextView: View>: View {
    let items: EnumeratedSequence<[String]>
    let horizontalSpacing: CGFloat
    let verticalSpacing: CGFloat
    let circledNumberStrokeColor: Color
    let textView: (String) -> TextView
    
    /// Initialises a new EnumeratedList
    /// - Parameters:
    ///   - items: Items to be shown on the right hand sides, next to the numbers.
    ///   For each element the enumeration item gets incremented.
    ///   - horizontalSpacing: The spacing between the enumeration and text.
    ///   - verticalSpacing: The vertical spacing between elements
    ///   - circledNumberStrokeColor: Stroke colour used around the enumerations
    ///   - textBuilder: A view builder to modify the shown text on the right hand side for each element.
    init(items: EnumeratedSequence<[String]>,
         horizontalSpacing: CGFloat = 12,
         verticalSpacing: CGFloat = 16,
         circledNumberStrokeColor: Color,
         @ViewBuilder
         textBuilder: @escaping (String) -> TextView) {
        self.items = items
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.circledNumberStrokeColor = circledNumberStrokeColor
        self.textView = textBuilder
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: verticalSpacing) {
            ForEach(Array(items), id: \.element) { index, item in
                descriptionText(index: index, description: item)
            }
        }
    }
    
    private func descriptionText(index: Int, description: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: horizontalSpacing) {
            CircledNumber(
                number: index + 1,
                length: 24,
                strokeContent: circledNumberStrokeColor,
                content: { Text("\($0)") })
            textView(description)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#if DEBUG
#Preview {
    EnumeratedList(
        items: [
            "*Recipe for a nice commit message*",
            "1 clear purpose (don’t be afraid to reduce scope)",
            "2 cups of meaningful context (preferably bug-free)",
            "1 well-chopped action verb (e.g., “fix,” “add,” “update”)",
            "A handful of concise explanations (remove unnecessary details)",
            "1 tsp of consistency (refer to previous commit messages for taste)",
            "Optional: sprinkle with emojis, but use sparingly (:sparkles: for feature additions, :bug: for bug fixes)",
            "Thanks ChatGPT"
        ].enumerated(),
        circledNumberStrokeColor: Color.black
    ) { text in
        Text(text)
    }
}
#endif
