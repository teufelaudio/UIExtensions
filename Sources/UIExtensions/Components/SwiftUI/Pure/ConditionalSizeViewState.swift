// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import CoreGraphics
import Foundation

/// View State to be used with ConditionalSizeView
/// It provides a list of diferent View States that will differ according to the available size given by the parent
/// The best option for View State will be anything that fits in the parent's frame, and also enforcing aspect is
/// available in case only horizontal views are allowed in horizontal parents, and only vertical views are allowed
/// in vertical parents.
/// Otherwise, anything that fits both dimensions - regardles of aspect - will be chosen, having priority those with
/// more pixels and less priority those with fewer pixels. If pixel count is the same, aspect decides. Hashable ensure
/// that you can't have 2 options with exact same height and width.
public struct ConditionalSizeViewState<ContentState: Equatable>: Equatable {
    struct Option: Hashable {
        init(size: CGSize, contentState: ContentState) {
            self.size = size
            self.contentState = contentState
        }

        let size: CGSize
        let contentState: ContentState

        func hash(into hasher: inout Hasher) {
            // We should only consider the size for hashing the options.
            hasher.combine(size.width)
            hasher.combine(size.height)
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            // We should only consider the size when implementing Equatable on the options.
            lhs.size == rhs.size
        }
    }

    let options: Set<Option>
    let enforceAspect: Bool

    public init(options: [(size: CGSize, contentState: ContentState)], enforceAspect: Bool = false) {
        self.options = Set(options.map { .init(size: $0.size, contentState: $0.contentState) })
        self.enforceAspect = enforceAspect
    }

    init(options: Set<Option>, enforceAspect: Bool = false) {
        self.options = options
        self.enforceAspect = enforceAspect
    }

    func bestOption(for availableSize: CGSize) -> Option? {
        options
            .filter { option in
                option.size.height <= availableSize.height &&   // It has to fit vertically,
                option.size.width <= availableSize.width &&     // it has to fit horizontally, and
                (
                    !enforceAspect ||                           // either enforce aspect is not desired
                    ((option.size.height >= option.size.width)  // or aspect (horizontal/vertical) must match
                        == (availableSize.height >= availableSize.width))
                )
            }
            .max(by: {
                let lhsHeight = $0.size.height
                let rhsHeight = $1.size.height

                let lhsWidth = $0.size.width
                let rhsWidth = $1.size.width

                let lhsPixels = lhsHeight * lhsWidth
                let rhsPixels = rhsHeight * rhsWidth

                if lhsPixels != rhsPixels {         // When they have different amount of pixels,
                    return lhsPixels < rhsPixels    // sort by pixels on ascending order (max will pick the larger)
                }
                                                    // otherwise check if available space is vertical
                let availableSpaceIsVertical = availableSize.height >= availableSize.width

                if availableSpaceIsVertical {        // if available space is vertical (or square)
                    return lhsHeight < rhsHeight     // sort by height on ascending order (max will pick the larger),
                } else {
                    return lhsWidth < rhsWidth       // but if it's horizontal, then sort by width on ascending order
                }

            })
    }
}
