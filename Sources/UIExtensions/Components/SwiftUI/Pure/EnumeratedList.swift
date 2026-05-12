// Copyright © 2024 Lautsprecher Teufel GmbH. All rights reserved.

import SwiftUI

/// A vertical container that enumerates a collection of items into rows,
/// similar to SwiftUI's `List(_:rowContent:)`.
///
/// `EnumeratedList` iterates the provided data and hands each `(index, element)`
/// pair to the caller's row builder. Rows are produced from the outside, so
/// accessibility, gesture, or any other view modifiers can be applied directly
/// at the call site where the caller has full context (index, total count,
/// localised labels, etc.). Pair it with ``EnumeratedListRow`` to render the
/// circled-number + description layout, or return any view of your choice.
///
/// ```swift
/// EnumeratedList(items) { index, item in
///     EnumeratedListRow(
///         number: index + 1,
///         circledNumberStrokeColor: .black,
///         enumerationContent: { Text("\($0)") }
///     ) {
///         Text(item)
///     }
///     .accessibilityRepresentation {
///         Text("Step \(index + 1) of \(items.count), \(item)")
///     }
/// }
/// ```
public struct EnumeratedList<Data: RandomAccessCollection, RowContent: View>: View {
    private let data: Data
    private let verticalSpacing: CGFloat
    private let rowContent: (Int, Data.Element) -> RowContent

    /// Initialises a new EnumeratedList.
    /// - Parameters:
    ///   - data: The collection of items to enumerate.
    ///   - verticalSpacing: The vertical spacing between rows.
    ///   - rowContent: A view builder that receives the zero-based index and
    ///     the element, and produces the row view. Use ``EnumeratedListRow``
    ///     (or any other view) to compose each row.
    public init(
        _ data: Data,
        verticalSpacing: CGFloat = 16,
        @ViewBuilder rowContent: @escaping (Int, Data.Element) -> RowContent
    ) {
        self.data = data
        self.verticalSpacing = verticalSpacing
        self.rowContent = rowContent
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: verticalSpacing) {
            ForEach(Array(data.enumerated()), id: \.offset) { index, element in
                rowContent(index, element)
            }
        }
    }
}

/// A single row designed to be used inside an ``EnumeratedList``. Lays out a
/// ``CircledNumber`` followed by an arbitrary description view.
public struct EnumeratedListRow<EnumerationContent: View, Description: View>: View {
    private let number: Int
    private let horizontalSpacing: CGFloat
    private let circleLength: CGFloat
    private let circledNumberStrokeColor: Color
    private let enumerationContent: (Int) -> EnumerationContent
    private let description: Description

    /// Initialises a new EnumeratedListRow.
    /// - Parameters:
    ///   - number: The number shown inside the circled enumeration.
    ///   - horizontalSpacing: The spacing between the circled number and the
    ///     description.
    ///   - circleLength: The diameter of the circled-number view.
    ///   - circledNumberStrokeColor: Stroke color used around the circled number.
    ///   - enumerationContent: A view builder that produces the contents shown
    ///     inside the circled number for the given integer.
    ///   - description: A view builder that produces the description view shown
    ///     next to the circled number.
    public init(
        number: Int,
        horizontalSpacing: CGFloat = 12,
        circleLength: CGFloat = 24,
        circledNumberStrokeColor: Color,
        @ViewBuilder enumerationContent: @escaping (Int) -> EnumerationContent,
        @ViewBuilder description: () -> Description
    ) {
        self.number = number
        self.horizontalSpacing = horizontalSpacing
        self.circleLength = circleLength
        self.circledNumberStrokeColor = circledNumberStrokeColor
        self.enumerationContent = enumerationContent
        self.description = description()
    }

    public var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: horizontalSpacing) {
            CircledNumber(
                number: number,
                length: circleLength,
                strokeContent: circledNumberStrokeColor,
                content: { enumerationContent($0) }
            )

            description
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#if DEBUG
#Preview {
    let items = [
        "*Recipe for a nice commit message*",
        "1 clear purpose (don't be afraid to reduce scope)",
        "2 cups of meaningful context (preferably bug-free)",
        "1 well-chopped action verb (e.g., fix, add, update)",
        "A handful of concise explanations (remove unnecessary details)",
        "1 tsp of consistency (refer to previous commit messages for taste)",
        "Optional: sprinkle with emojis, but use sparingly",
        "Thanks ChatGPT"
    ]
    EnumeratedList(items) { index, item in
        EnumeratedListRow(
            number: index + 1,
            circledNumberStrokeColor: .black,
            enumerationContent: { Text("\($0)") }
        ) {
            Text(item)
        }
    }
}
#endif
