//
//  PageView.swift
//  UIExtensions
//
//  Created by Luis Reisewitz on 20.01.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

#if canImport(UIKit)
import SwiftUI
import UIKit

/// A view displaying multiple views in a page like view. Using `UIPageViewController` internally.
/// Originally taken from Apple Tutorial https://developer.apple.com/tutorials/swiftui/interfacing-with-uikit
/// but heavily modified to actually work in a dynamic SwiftUI context.
/// - Warning:Before using, check `PagingScrollView` and implement `ForEach` type view creation
///     instead of making the views implement `Equatable`.
public struct PageView<DataCollection: RandomAccessCollection, PageType: View>: UIViewControllerRepresentable
where DataCollection.Element: Identifiable, DataCollection: Equatable {
    // MARK: Content Properties

    /// Collection of data to show.
    let items: DataCollection
    /// ViewBuilder for a single content page.
    let content: (DataCollection.Element) -> PageType
    /// Index of current page 0..N-1
    @Binding var activePageIndex: DataCollection.Index

    /// Creates a view that wraps an `UIPageViewController` internally.
    /// - Parameters:
    ///   - activePageIndex: Binding to the active Page Index. Will be updated if the user scrolls. Can be used to control a PageControl.
    ///   - items: The collection of items used by each page to render its content.
    ///   - content: ViewBuilder for a single content page view. The view builder closure will receive each row from the data collection and it must
    ///              return the View representing each page.
    public init(activePageIndex: Binding<DataCollection.Index>,
                items: DataCollection,
                @ViewBuilder content: @escaping (DataCollection.Element) -> PageType) {
        self.items = items
        self.content = content
        self._activePageIndex = activePageIndex
    }

    public func makeCoordinator() -> PageViewCoordinator<DataCollection, PageType> {
        // See Coordinator class and updateUIViewController for more information
        // about the lifecycle of all of these parts (PageView, Coordinator, UIPageViewController).
        return Coordinator(items: items, activePageIndex: $activePageIndex, content: content)
    }

    public func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal)
        pageViewController.dataSource = context.coordinator.pageDataSource
        pageViewController.delegate = context.coordinator.pageDataSource

        // Configure the `UIPageViewController` initially once.
        pageViewController.setViewControllers(
            [context.coordinator.viewController(at: items.startIndex)],
            direction: .forward,
            animated: false
        )

        return pageViewController
    }

    public func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        // This method is called when the `PageView` is recreated by SwiftUI.
        // We are responsible here for updating the `UIPageViewController` and
        // the `Coordinator` to reflect the new configuration.
        // For this we need to do some things.
        // - Update the behavioral properties of the Coordinator in case they changed when recreating this view.
        // - Check if we need to update the `pages` of the coordinator.
        // - If we updated the pages, we also need to update the currently shown page of the `UIPageViewController` instance.
        // No matter if the view array is the same, we should update the Coordinator
        // in case some configuration changed.

        // Compare the newly configured views (`controllers`) with the already
        // existing views that the UIPageViewController knows about
        // (`context.coordinator.controllers`).
        guard items != context.coordinator.items else {
            // Items array is the same. Don't do anything.
            return
        }

        // View array is different. We now need to replace the coordinator's
        // view array and also the current page in the `UIPageViewController`,
        // otherwise Paging will break later (because the views are not gonna
        // be the same.
        context.coordinator.items = items

        // We don't animate the change. This way the user does not even notice
        // that are replacing the view under their finger.
        pageViewController.setViewControllers([context.coordinator.viewController(at: items.startIndex)],
                                              direction: .forward,
                                              animated: false)
    }

    /// This is the coordinator for the UIPageViewController. It is responsible for applying the current `PageView`
    /// configuration to the `UIPageViewController` that was created in `makeUIViewController`.
    /// The coordinator is created once. We pass in the current view (`self`)
    /// to let the coordinator copy the view's configuration. `PageView.updateUIViewController`
    /// is called once the view struct is recreated. It is responsible for updating the `UIPageViewController`
    /// of the new configuration, the `PageView` also needs to update this `Coordinator` in
    /// based on the current configuration of the NEWLY CREATED `PageView`. To keep track
    /// `updateUIViewController`.
    public final class PageViewCoordinator<Data: RandomAccessCollection, Content: View>
    where Data.Element: Identifiable, Data: Equatable {
        fileprivate var items: Data
        private let content: (Data.Element) -> Content
        @Binding private var activePageIndex: Data.Index

        func viewController(at index: Data.Index) -> UIViewController {
            let element = self.items[index]
            return IdentifiableHostingController(id: element.id, content: self.content(element))
        }

        fileprivate lazy var pageDataSource: PageControllerDataSource = {
            PageControllerDataSource(
                pageBefore: { [weak self] viewController in

                    guard let self = self,
                        let hostingController = viewController as? IdentifiableHostingController<Data.Element.ID, Content> else {
                        return nil
                    }

                    guard let index = self.items.firstIndex(where: { $0.id == hostingController.id }) else { return nil }

                    let previousIndex = self.items.index(before: index)
                    guard previousIndex >= self.items.startIndex && previousIndex < self.items.endIndex else { return nil }
                    return self.viewController(at: previousIndex)
                },
                pageAfter: { [weak self] viewController in
                    guard let self = self,
                        let hostingController = viewController as? IdentifiableHostingController<Data.Element.ID, Content> else {
                        return nil
                    }

                    guard let index = self.items.firstIndex(where: { $0.id == hostingController.id }) else { return nil }

                    let nextIndex = self.items.index(after: index)
                    guard nextIndex >= self.items.startIndex && nextIndex < self.items.endIndex else { return nil }
                    return self.viewController(at: nextIndex)
                },
                didFinishAnimating: { [weak self] pageViewController, finished, previousViewControllers, completed in
                    guard let self = self,
                        completed,
                        let visibleViewController = pageViewController.viewControllers?.first,
                        let hostingController = visibleViewController as? IdentifiableHostingController<Data.Element.ID, Content>,
                        let index = self.items.firstIndex(where: { $0.id == hostingController.id }) else { return }

                    self.activePageIndex = index
                }
            )
        }()

        init(items: Data, activePageIndex: Binding<Data.Index>, content: @escaping (Data.Element) -> Content) {
            self.items = items
            self._activePageIndex = activePageIndex
            self.content = content
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

    @objc public func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        pageBefore(viewController)
    }

    @objc public func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        pageAfter(viewController)
    }

    @objc public func pageViewController(_ pageViewController: UIPageViewController,
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
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#endif
