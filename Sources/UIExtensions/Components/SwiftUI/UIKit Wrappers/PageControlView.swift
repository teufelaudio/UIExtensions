//
//  PageControlView.swift
//  UIExtensions
//
//  Created by Luiz Rodrigo Martins Barbosa on 10.06.20.
//  Copyright © 2020 Lautsprecher Teufel GmbH. All rights reserved.
//

import SwiftUI
import UIKit

public struct PageControlView: UIViewRepresentable {
    @Binding private var currentPage: Int
    private let numberOfPages: Int
    private let pageIndicatorTintColor: UIColor?
    private let currentPageIndicatorTintColor: UIColor?

    public init(numberOfPages: Int, currentPage: Binding<Int>) {
        self.init(numberOfPages: numberOfPages, currentPage: currentPage, pageIndicatorTintColor: nil, currentPageIndicatorTintColor: nil)
    }

    private init(numberOfPages: Int, currentPage: Binding<Int>, pageIndicatorTintColor: UIColor?, currentPageIndicatorTintColor: UIColor?) {
        self.numberOfPages = numberOfPages
        self._currentPage = currentPage
        self.pageIndicatorTintColor = pageIndicatorTintColor
        self.currentPageIndicatorTintColor = currentPageIndicatorTintColor
    }

    public func makeUIView(context: Context) -> UIPageControl {
        let view = UIPageControl()
        view.numberOfPages = numberOfPages
        view.currentPage = currentPage

        pageIndicatorTintColor.map { view.pageIndicatorTintColor = $0 }
        currentPageIndicatorTintColor.map { view.currentPageIndicatorTintColor = $0 }

        view.addTarget(context.coordinator, action: #selector(Coordinator.updateCurrentPage(sender:)), for: .valueChanged)
        return view
    }

    public func updateUIView(_ uiView: UIPageControl, context: Context) {
        // Update our view and then add/remove the target
        uiView.numberOfPages = numberOfPages
        uiView.currentPage = currentPage
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    /// Coordinator for this PageIndicator. Used only to update the source binding when a user taps on a
    /// page "dot" itself.
    public class Coordinator: NSObject {
        private var control: PageControlView

        init(_ control: PageControlView) {
            self.control = control
            super.init()
        }

        @objc func updateCurrentPage(sender: UIPageControl) {
            control.currentPage = sender.currentPage
        }
    }
}

extension PageControlView {
    public func pageIndicatorTintColor(_ color: UIColor) -> PageControlView {
        PageControlView(
            numberOfPages: numberOfPages,
            currentPage: $currentPage,
            pageIndicatorTintColor: color,
            currentPageIndicatorTintColor: currentPageIndicatorTintColor
        )
    }

    public func currentPageIndicatorTintColor(_ color: UIColor) -> PageControlView {
        PageControlView(
            numberOfPages: numberOfPages,
            currentPage: $currentPage,
            pageIndicatorTintColor: pageIndicatorTintColor,
            currentPageIndicatorTintColor: color
        )
    }
}
