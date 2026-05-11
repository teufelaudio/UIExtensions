// Copyright © 2024 Lautsprecher Teufel GmbH. All rights reserved.

import SwiftUI

/// A vertical container that lays out enumerated rows, similar to SwiftUI's `List`.
///
/// `EnumeratedList` only owns the vertical layout: rows are injected by the
/// caller via the `content` view builder. Pair it with ``EnumeratedListRow``
/// (or any other view) to compose each row. Because rows are provided from the
/// outside, accessibility, gesture, or any other view modifiers can be applied
/// directly at the call site where the caller has full context (index, total
/// count, localised labels, etc.).
///
/// ```swift
/// EnumeratedList {
///     ForEach(Array(items.enumerated()), id: \.offset) { index, item in
///         EnumeratedListRow(number: index + 1, circledNumberStrokeColor: .black) {
///             Text(item)
///         }
///         .accessibilityRepresentation {
///             Text("Step \(index + 1) of \(items.count), \(item)")
///         }
///     }
/// }
/// ```
public struct EnumeratedList<Content: View>: View {
    private let verticalSpacing: CGFloat
    private let content: Content

    /// Initialises a new EnumeratedList.
    /// - Parameters:
    ///   - verticalSpacing: The vertical spacing between rows.
    ///   - content: A view builder that produces the rows of the list. Use
    ///     ``EnumeratedListRow`` (or any other view) to compose each row.
    public init(
        verticalSpacing: CGFloat = 16,
        @ViewBuilder content: () -> Content
    ) {
        self.verticalSpacing = verticalSpacing
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: verticalSpacing) {
            content
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
    return EnumeratedList {
        ForEach(Array(items.enumerated()), id: \.offset) { index, item in
            EnumeratedListRow(
                number: index + 1,
                circledNumberStrokeColor: .black
            ) {
                Text(item)
            }
            .accessibilityRepresentation {
                Text("Step \(index + 1) of \(items.count), \(item)")
            }
        }
    }
}
#endif
