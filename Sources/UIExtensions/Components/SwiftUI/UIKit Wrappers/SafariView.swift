// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

#if canImport(UIKit) && canImport(SafariServices)
import SafariServices
import SwiftUI

public struct SafariView: View {
    private let url: URL

    public init(url: URL) {
        self.url = url
    }

    public var body: some View {
        SafariViewControllerWrapper(url: url)
            .edgesIgnoringSafeArea(.all)
    }
}

private struct SafariViewControllerWrapper: UIViewControllerRepresentable {
    private let url: URL

    init(url: URL) {
        self.url = url
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariViewControllerWrapper>) -> SFSafariViewController {
        let viewController = SFSafariViewController(url: url)
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController,
                                context: UIViewControllerRepresentableContext<SafariViewControllerWrapper>) {}
}
#endif
