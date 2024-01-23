// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

#if DEBUG && canImport(SwiftUI) && canImport(UIKit)
import SwiftUI
import UIExtensions

// MARK: - snapshotTestBorder
extension View {
    /// This function allows you to add a custom border to a view for snapshot testing purposes.
    ///
    /// - Parameters:
    ///     - title: A string that will be used to generate the repeated title inside the border. Defaults to "SnapshotTest".
    ///
    /// - Returns: A modified version of the view that has a custom border with a repeated title inside it.
    public func snapshotTestBorder(_ title: String = "SnapshotTest") -> some View {
        modifier(SnapshotTestBorderViewModifier(title))
    }
}

struct SnapshotTestBorderViewModifier: ViewModifier {
    @State
    private var contentSize: CGSize = .zero
    private var fontSize: CGFloat {
        min(contentSize.width, contentSize.height) * 0.1
    }
    private var repeatedTitle: String {
        var mutableRepeatedTitle = title
        while max(contentSize.height, contentSize.width)
                > mutableRepeatedTitle.width(for: .systemFont(ofSize: fontSize)) {
            mutableRepeatedTitle.append(title)
        }
        return mutableRepeatedTitle
    }
    private let title: String

    init(_ title: String) {
        self.title = title
    }

    func body(content: Content) -> some View {
            content
                .measureView { contentSize = $0 }
                .border(
                    {
                        Text(repeatedTitle)
                            .font(.system(size: fontSize))
                            .foregroundLinearGradient(
                                [
                                    .red,
                                    .orange,
                                    .yellow,
                                    .green,
                                    .init(red: 63, green: 0, blue: 255),
                                    .purple
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .lineLimit(1)
                            .truncationMode(.middle)
                            .multilineTextAlignment(.center)
                    },
                    dividerColor: .red,
                    dividerWidth: 0.4
                )
    }
}
#endif
