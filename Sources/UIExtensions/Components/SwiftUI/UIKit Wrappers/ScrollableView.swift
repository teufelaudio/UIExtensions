//
//  ScrollableView.swift
//  UIExtensions
//
//  Created by Luis Reisewitz on 24.03.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

#if canImport(UIKit)
import SwiftUI
import UIKit

// Taken from https://gist.github.com/jfuellert/67e91df63394d7c9b713419ed8e2beb7
// and slightly modified to fit our needs. I removed the `offset` binding as we
// did not need it and it caused "Modifying State during View Update" runtime
// issues (updateUIViewController -> setContentSize -> scrollViewDidScroll -> changing offset binding).

/// A ScrollView replacement that's actually usable.
///
/// - Warning: NavigationLinks that are contained in `Content` don't work.
public struct ScrollableView<Content: View>: UIViewControllerRepresentable {

    // MARK: - Type
    public typealias UIViewControllerType = UIScrollViewController<Content>

    // MARK: - Properties
    var content: () -> Content
    var showsScrollIndicator: Bool
    var axis: Axis

    // MARK: - Init
    public init(showsScrollIndicator: Bool = true,
                axis: Axis = .vertical,
                @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.showsScrollIndicator = showsScrollIndicator
        self.axis = axis
    }

    // MARK: - Updates
    public func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> UIViewControllerType {

        let scrollViewController = UIScrollViewController(rootView: self.content(), axis: self.axis)
        scrollViewController.scrollView.showsVerticalScrollIndicator = self.showsScrollIndicator
        scrollViewController.scrollView.showsHorizontalScrollIndicator = self.showsScrollIndicator
        scrollViewController.scrollView.alwaysBounceVertical = true

        return scrollViewController
    }

    public func updateUIViewController(_ viewController: UIViewControllerType, context: UIViewControllerRepresentableContext<Self>) {
        viewController.updateContent(self.content)
    }
}

public final class UIScrollViewController<Content: View>: UIViewController, UIScrollViewDelegate, ObservableObject {

    // MARK: - Properties
    let hostingController: UIHostingController<Content>
    private let axis: Axis
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        scrollView.backgroundColor                           = .clear

        return scrollView
    }()

    // MARK: - Init
    init(rootView: Content, axis: Axis) {
        self.hostingController = UIHostingController<Content>(rootView: rootView)
        self.hostingController.view.backgroundColor = .clear
        self.axis = axis
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: - Update
    func updateContent(_ content: () -> Content) {

        self.hostingController.rootView = content()
        self.scrollView.addSubview(self.hostingController.view)

        updateScrollviewContentSize()
    }

    func updateScrollviewContentSize() {
        var contentSize: CGSize = self.hostingController.view.intrinsicContentSize

        switch axis {
        case .vertical:
            contentSize.width = self.scrollView.frame.width
        case .horizontal:
            contentSize.height = self.scrollView.frame.height
        }

        self.hostingController.view.frame.size = contentSize
        self.scrollView.contentSize = contentSize
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.scrollView)
        self.createConstraints()
        self.view.layoutIfNeeded()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // TBA-400: We need to update the content size here. When the device orientation
        // changes, the scrollview re-renders before the frame is updated.
        // Which means it uses the old values for its contentSize, which then
        // breaks the layout (too wide or too narrow).
        // To prevent this, we re-set the content size after layoutSubviews.
        updateScrollviewContentSize()
    }

    // MARK: - UIScrollViewDelegate
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {  }

    // MARK: - Constraints
    fileprivate func createConstraints() {
        NSLayoutConstraint.activate([
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}
#endif
