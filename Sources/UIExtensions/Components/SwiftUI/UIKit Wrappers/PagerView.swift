//
//  PagerView.swift
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
public struct PagerView<PageViewType: View & Equatable>: UIViewControllerRepresentable {
    /// The list of currently available views. These are only used to pass them to the `Coordinator`, who is then
    /// responsible for actually using them for the `UIPageViewController`.
    private var pages: [PageViewType]

    /// Binding to the currentPage, which is injected from the outside. This is used here to set
    /// the page number after the user scrolled from one page to the other. The coordinator is doing that.
    @Binding private var currentPage: Int

    /// If the Pager should wrap around to the first View if the user scrolls past the last View.
    /// The coordinator is deciding based on this in the `UIPageViewControllerDataSource` methods.
    private var wrapAround = true

    /// Creates a view displaying multiple views in a page like view. Using `UIPageViewController` internally.
    /// - Parameters:
    ///   - pages: The list of pages to display.
    ///   - currentPage: Binding to the currentPage. Will be updated if the user scrolls. Can be used to control a PageControl.
    ///   - wrapAround: If the Pager should wrap around to the first View if the user scrolls past the last View.
    public init(pages: [PageViewType], currentPage: Binding<Int>, wrapAround: Bool = false) {
        self.pages = pages
        self._currentPage = currentPage
        self.wrapAround = wrapAround
    }

    public func makeCoordinator() -> Coordinator {
        // See Coordinator class and updateUIViewController for more information
        // about the lifecycle of all of these parts (PagerView, Coordinator, UIPageViewController).
        return Coordinator(self)
    }

    public func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal)
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator

        // Configure the `UIPageViewController` initially once.
        pageViewController.setViewControllers([context.coordinator.pages[0].hosted],
                                              direction: .forward,
                                              animated: false)

        return pageViewController
    }

    public func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        // This method is called when the `PagerView` is recreated by SwiftUI.
        // We are responsible here for updating the `UIPageViewController` and
        // the `Coordinator` to reflect the new configuration.
        // For this we need to do some things.
        // - Update the behavioral properties of the Coordinator in case they changed when recreating this view.
        // - Check if we need to update the `pages` of the coordinator.
        // - If we updated the pages, we also need to update the currently shown page of the `UIPageViewController` instance.
        // No matter if the view array is the same, we should update the Coordinator
        // in case some configuration changed.
        context.coordinator.wrapAround = self.wrapAround

        // Compare the newly configured views (`controllers`) with the already
        // existing views that the UIPageViewController knows about
        // (`context.coordinator.controllers`).
        guard pages != context.coordinator.pages else {
            // View array is the same. Don't do anything.
            return
        }

        // View array is different. We now need to replace the coordinator's
        // view array and also the current page in the `UIPageViewController`,
        // otherwise Paging will break later (because the views are not gonna
        // be the same.
        context.coordinator.pages = pages

        // We don't animate the change. This way the user does not even notice
        // that are replacing the view under their finger.
        let viewController = context.coordinator.pages[currentPage].hosted
        pageViewController.setViewControllers([viewController],
                                              direction: .forward,
                                              animated: false)
    }

    /// This is the coordinator for the UIPageViewController. It is responsible for applying the current `PagerView`
    /// configuration to the `UIPageViewController` that was created in `makeUIViewController`.
    /// The coordinator is created once. We pass in the current view (`self`)
    /// to let the coordinator copy the view's configuration. `PagerView.updateUIViewController`
    /// is called once the view struct is recreated. It is responsible for updating the `UIPageViewController`
    /// based on the current configuration of the NEWLY CREATED `PagerView`. To keep track
    /// of the new configuration, the `PagerView` also needs to update this `Coordinator` in
    /// `updateUIViewController`.
    public class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        /// The list of currently available views.
        var pages: [PageViewType]

        /// Binding to the currentPage, which is injected from the outside. This is used here to set
        /// the page number after the user scrolled from one page to the other.
        @Binding var currentPage: Int

        /// If the Pager should wrap around to the first View if the user scrolls past the last View.
        var wrapAround: Bool

        init(_ pagerView: PagerView) {
            self.pages = pagerView.pages
            self._currentPage = pagerView.$currentPage
            self.wrapAround = pagerView.wrapAround
        }

        public func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerBefore viewController: UIViewController) -> UIViewController? {
            // Compare the current view (taken from the `UIHostingController`)
            // and our current view array. Find the index of the current view
            // and then return the next view accordingly (wrapped in a
            // `UIHostingController` as well).
            guard let hostingController = viewController as? UIHostingController<PageViewType> else {
                return nil
            }

            let pageView = hostingController.rootView
            guard let index = pages.firstIndex(of: pageView) else {
                return nil
            }

            // We have reached the first element. Wrap around the view array if needed
            if index == 0 {
                if wrapAround, let page = pages.last {
                    return page.hosted
                } else {
                    return nil
                }
            }

            return pages[index - 1].hosted
        }

        public func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerAfter viewController: UIViewController) -> UIViewController? {
            // Compare the current view (taken from the `UIHostingController`)
            // and our current view array. Find the index of the current view
            // and then return the next view accordingly (wrapped in a
            // `UIHostingController` as well).
            guard let hostingController = viewController as? UIHostingController<PageViewType> else {
                return nil
            }

            let pageView = hostingController.rootView
            guard let index = pages.firstIndex(of: pageView) else {
                return nil
            }

            // We have reached the last element. Wrap around the view array if needed.
            if index + 1 == pages.count {
                if wrapAround, let page = pages.first {
                    return page.hosted
                } else {
                    return nil
                }
            }

            return pages[index + 1].hosted
        }

        public func pageViewController(_ pageViewController: UIPageViewController,
                                       didFinishAnimating finished: Bool,
                                       previousViewControllers: [UIViewController],
                                       transitionCompleted completed: Bool) {
            if completed,
                let visibleViewController = pageViewController.viewControllers?.first,
                let pageView = (visibleViewController as? UIHostingController<PageViewType>)?.rootView,
                let index = pages.firstIndex(of: pageView) {
                currentPage = index
            }
        }
    }
}
#endif
