// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

#if canImport(UIKit)
import FoundationExtensions
import SwiftUI
import UIKit

/// A view displaying multiple views in a page like view. Using `UIPageViewController` internally.
/// Originally taken from Apple Tutorial https://developer.apple.com/tutorials/swiftui/interfacing-with-uikit
/// but heavily modified to actually work in a dynamic SwiftUI context.
public struct PageView<DataCollection: RandomAccessCollection, PageType: View>: UIViewControllerRepresentable
where DataCollection.Element: Identifiable, DataCollection: Equatable {

    // MARK: Content Properties
    /// Collection of items provided when the PageView is created.
    /// We only cache it to handover to the PageViewCoordinator when
    /// we create it. There will be the source-of-truth for the latest
    /// data collection
    private let receivedItems: DataCollection

    /// ViewBuilder for a single content page.
    private let content: (DataCollection.Element) -> PageType

    /// Index of current page 0..N-1
    @Binding private var activePageIndex: DataCollection.Index

    /// Creates a view that wraps an `UIPageViewController` internally.
    /// - Parameters:
    ///   - activePageIndex: Binding to the active Page Index. Will be updated if the user scrolls. Can be used to control a PageControl. Setting it
    ///                      from outside will also swipe to the proper tab, animated.
    ///   - items: The collection of items used by each page to render its content. Elements should be identifiable and equatable.
    ///   - content: ViewBuilder for a single content page view. The view builder closure will receive each row from the data collection and it must
    ///              return the View representing each page.
    public init(activePageIndex: Binding<DataCollection.Index>,
                items: DataCollection,
                @ViewBuilder content: @escaping (DataCollection.Element) -> PageType) {
        self.receivedItems = items
        self.content = content
        self._activePageIndex = activePageIndex
    }

    public func makeCoordinator() -> PageViewCoordinator {
        // See PageViewCoordinator class and updateUIViewController for more information
        // about the lifecycle of all of these parts (PageView, PageViewCoordinator, UIPageViewController).
        return PageViewCoordinator(
            parent: self,
            items: receivedItems,
            initialIndex: activePageIndex
        )
    }

    public func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal)

        pageViewController.dataSource = context.coordinator.pageDataSource
        pageViewController.delegate = context.coordinator.pageDataSource
        pageViewController.view.backgroundColor = .clear

        context.coordinator.items = receivedItems

        // Configure the `UIPageViewController` initially once.
        pageViewController.setViewControllers(
            [
                context.coordinator.viewController(for: context.coordinator.items[safe: activePageIndex]
                    ?? context.coordinator.items.last)
            ].compactMap(identity),
            direction: .forward,
            animated: false
        )

        return pageViewController
    }

    public func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        // This method is called when the `PageView` is recreated by SwiftUI.
        // We are responsible here for updating the `UIPageViewController` and
        // the `PageViewCoordinator` to reflect the new configuration.

        // We only have to change the UIPageViewController if the collection has changed (even when it's not the presented item, because we need
        // to refresh "page before" and "page after"), or the collection is the same but the selected page is different.
        guard context.coordinator.items != receivedItems ||
            context.coordinator.lastKnownSelectedIndex != activePageIndex else {
            return
        }

        context.coordinator.items = receivedItems
        context.coordinator.parent = self

        let formerIndex = context.coordinator.lastKnownSelectedIndex

        let element = context.coordinator.items[safe: activePageIndex] ?? context.coordinator.items.last

        let direction: UIPageViewController.NavigationDirection = activePageIndex > formerIndex
            ? .forward
            : .reverse

        let animated =
            (activePageIndex != formerIndex || activePageIndex >= context.coordinator.items.endIndex)
                && !context.transaction.disablesAnimations && context.transaction.animation != nil

        context.coordinator.lastKnownSelectedIndex = activePageIndex

        pageViewController.setViewControllers([context.coordinator.viewController(for: element)].compactMap(identity),
                                              direction: direction,
                                              animated: animated)
    }
}

extension PageView {
    /// This is the coordinator for the UIPageViewController. It is responsible for applying the current `PageView`
    /// configuration to the `UIPageViewController` that was created in `makeUIViewController`.
    /// The coordinator is created once. We pass in the current view (`self`)
    /// to let the coordinator copy the view's configuration. `PageView.updateUIViewController`
    /// is called once the view struct is recreated. It is responsible for updating the `UIPageViewController`
    /// of the new configuration, the `PageView` also needs to update this `PageViewCoordinator` in
    /// based on the current configuration of the NEWLY CREATED `PageView`.
    public final class PageViewCoordinator {
        fileprivate var parent: PageView

        // This is the source-of-truth for collection of items.
        fileprivate var items: DataCollection

        // Cached element that is being presented.
        var lastKnownSelectedIndex: DataCollection.Index

        fileprivate lazy var pageDataSource: PageControllerDataSource = {
            PageControllerDataSource(
                pageBefore: { [weak self] viewController in self?.pageBefore(viewController: viewController) },
                pageAfter: { [weak self] viewController in self?.pageAfter(viewController: viewController) },
                didFinishAnimating: { [weak self] pageViewController, finished, _, completed in
                    guard let self = self,
                        finished,
                        completed,
                        let visibleViewController = pageViewController.viewControllers?.first,
                        let hostingController = visibleViewController as? IdentifiableHostingController<DataCollection.Element.ID, PageType>,
                        let index = self.items.firstIndex(where: { $0.id == hostingController.id }) else { return }

                    self.lastKnownSelectedIndex = index
                    self.parent.activePageIndex = index
                }
            )
        }()

        init(
            parent: PageView,
            items: DataCollection,
            initialIndex: DataCollection.Index
        ) {
            self.parent = parent
            self.items = items
            self.lastKnownSelectedIndex = initialIndex
        }

        func pageBefore(viewController: UIViewController) -> UIViewController? {
            guard let hostingController = viewController as? IdentifiableHostingController<DataCollection.Element.ID, PageType> else {
                return nil
            }

            guard let index = items.firstIndex(where: { $0.id == hostingController.id }) else { return nil }

            let previousIndex = items.index(before: index)
            guard previousIndex >= items.startIndex && previousIndex < items.endIndex else { return nil }
            return self.viewController(for: items[safe: previousIndex])
        }

        func pageAfter(viewController: UIViewController) -> UIViewController? {
            guard let hostingController = viewController as? IdentifiableHostingController<DataCollection.Element.ID, PageType> else {
                return nil
            }

            guard let index = items.firstIndex(where: { $0.id == hostingController.id }) else { return nil }

            let nextIndex = items.index(after: index)
            guard nextIndex >= items.startIndex && nextIndex < items.endIndex else { return nil }
            return self.viewController(for: items[safe: nextIndex])
        }

        func viewController(for element: DataCollection.Element?) -> UIViewController? {
            guard let element = element else { return nil }
            return IdentifiableHostingController(id: element.id, content: parent.content(element))
        }
    }
}

private final class PageControllerDataSource: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    private let pageBefore: (UIViewController) -> UIViewController?
    private let pageAfter: (UIViewController) -> UIViewController?
    private let didFinishAnimating: (UIPageViewController, Bool, [UIViewController], Bool) -> Void

    init(
        pageBefore: @escaping (UIViewController) -> UIViewController?,
        pageAfter: @escaping (UIViewController) -> UIViewController?,
        didFinishAnimating: @escaping (UIPageViewController, Bool, [UIViewController], Bool) -> Void
    ) {
        self.pageBefore = pageBefore
        self.pageAfter = pageAfter
        self.didFinishAnimating = didFinishAnimating
    }

    @objc func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        pageBefore(viewController)
    }

    @objc func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        pageAfter(viewController)
    }

    @objc func pageViewController(_ pageViewController: UIPageViewController,
                                  didFinishAnimating finished: Bool,
                                  previousViewControllers: [UIViewController],
                                  transitionCompleted completed: Bool) {
        didFinishAnimating(pageViewController, finished, previousViewControllers, completed)
    }
}

private class IdentifiableHostingController<ID: Hashable, Content: View>: UIHostingController<Content>, Identifiable {
    var id: ID

    init(id: ID, content: Content) {
        self.id = id
        super.init(rootView: content)
        self.view.backgroundColor = .clear
    }

    @objc dynamic required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#endif
