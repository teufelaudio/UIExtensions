//
//  PageControlDotsView.swift
//  UIExtensions
//
//  Created by Thomas Mellenthin on 29.03.21.
//  Copyright © 2021 Lautsprecher Teufel GmbH. All rights reserved.
//

import SwiftUI

/// UIPageControl() replacement.
///
/// There is PageControlView which wraps UIPageControl() but crashes with "AttributeGraph: cycle detected through attribute xxxxx".
public struct PageControlDotsView: View {

    @Binding private var currentPage: Int
    private let numberOfPages: Int
    private let pageIndicatorTintColor: Color
    private let currentPageIndicatorTintColor: Color

    public init(currentPage: Binding<Int>, numberOfPages: Int, pageIndicatorTintColor: Color, currentPageIndicatorTintColor: Color) {
        self._currentPage = currentPage
        self.numberOfPages = numberOfPages
        self.pageIndicatorTintColor = pageIndicatorTintColor
        self.currentPageIndicatorTintColor = currentPageIndicatorTintColor
    }

    public var body: some View {
        HStack {
            ForEach(0..<numberOfPages) { page in
                Circle()
                    .fill(currentPage == page ? currentPageIndicatorTintColor : pageIndicatorTintColor)
                    .animation(.easeInOut(duration: 0.1))
                    .frame(width: 8, height: 8, alignment: .center)
                    .padding(.horizontal, 0.8)
                    .onTapGesture {
                        withAnimation {
                            currentPage = page
                        }
                    }
            }
        }
        .padding(.vertical, 10)
    }
}

struct PageControlUIView_Previews: PreviewProvider {
    static var previews: some View {
        PageControlDotsView(currentPage: Binding.init(get: { 2 }, set: { _ in }),
                            numberOfPages: 5,
                            pageIndicatorTintColor: .gray,
                            currentPageIndicatorTintColor: .red)
    }
}
