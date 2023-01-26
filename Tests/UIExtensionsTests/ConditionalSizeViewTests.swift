// Copyright © 2023 Lautsprecher Teufel GmbH. All rights reserved.

import XCTest
@testable import UIExtensions

final class ConditionalSizeViewTests: XCTestCase {
    func testFitsAllSizesPickTheLargest() {
        let sut = ConditionalSizeViewState(options: [
            ConditionalSizeViewState.Option(size: CGSize(width: 200, height: 200), contentState: "200"),
            ConditionalSizeViewState.Option(size: CGSize(width: 300, height: 300), contentState: "300"),
            ConditionalSizeViewState.Option(size: CGSize(width: 400, height: 400), contentState: "400"),
            ConditionalSizeViewState.Option(size: CGSize(width: 500, height: 500), contentState: "500"),
            ConditionalSizeViewState.Option(size: CGSize(width: 600, height: 600), contentState: "600")
        ])

        let availableScreenSize = CGSize(width: 800, height: 600)

        XCTAssertEqual(sut.bestOption(for: availableScreenSize)?.contentState, "600")
    }

    func testDoesntFitLargestSizeBecauseOfTheHeight() {
        let sut = ConditionalSizeViewState(options: [
            ConditionalSizeViewState.Option(size: CGSize(width: 200, height: 200), contentState: "200"),
            ConditionalSizeViewState.Option(size: CGSize(width: 300, height: 300), contentState: "300"),
            ConditionalSizeViewState.Option(size: CGSize(width: 400, height: 400), contentState: "400"),
            ConditionalSizeViewState.Option(size: CGSize(width: 500, height: 500), contentState: "500"),
            ConditionalSizeViewState.Option(size: CGSize(width: 600, height: 600), contentState: "600")
        ])

        let availableScreenSize = CGSize(width: 800, height: 599)

        XCTAssertEqual(sut.bestOption(for: availableScreenSize)?.contentState, "500")
    }

    func testDoesntFitLargestSizeBecauseOfTheWidth() {
        let sut = ConditionalSizeViewState(options: [
            ConditionalSizeViewState.Option(size: CGSize(width: 200, height: 200), contentState: "200"),
            ConditionalSizeViewState.Option(size: CGSize(width: 300, height: 300), contentState: "300"),
            ConditionalSizeViewState.Option(size: CGSize(width: 400, height: 400), contentState: "400"),
            ConditionalSizeViewState.Option(size: CGSize(width: 500, height: 500), contentState: "500"),
            ConditionalSizeViewState.Option(size: CGSize(width: 600, height: 600), contentState: "600")
        ])

        let availableScreenSize = CGSize(width: 599, height: 600)

        XCTAssertEqual(sut.bestOption(for: availableScreenSize)?.contentState, "500")
    }

    func testDoesntFitLargestSizesBecauseOfTheBothDimensions() {
        let sut = ConditionalSizeViewState(options: [
            ConditionalSizeViewState.Option(size: CGSize(width: 300, height: 300), contentState: "300"),
            ConditionalSizeViewState.Option(size: CGSize(width: 600, height: 600), contentState: "600"),
            ConditionalSizeViewState.Option(size: CGSize(width: 400, height: 400), contentState: "400"),
            ConditionalSizeViewState.Option(size: CGSize(width: 200, height: 200), contentState: "200"),
            ConditionalSizeViewState.Option(size: CGSize(width: 500, height: 500), contentState: "500")
        ])

        let availableScreenSize = CGSize(width: 599, height: 499)

        XCTAssertEqual(sut.bestOption(for: availableScreenSize)?.contentState, "400")
    }

    func testPicksCorrectAspectHorizontal() {
        let sut = ConditionalSizeViewState(options: [
            ConditionalSizeViewState.Option(size: CGSize(width: 200, height: 400), contentState: "vertical"),
            ConditionalSizeViewState.Option(size: CGSize(width: 400, height: 200), contentState: "horizontal")
        ])

        let availableScreenSize = CGSize(width: 400, height: 200)

        XCTAssertEqual(sut.bestOption(for: availableScreenSize)?.contentState, "horizontal")
    }

    func testPicksCorrectAspectVertical() {
        let sut = ConditionalSizeViewState(options: [
            ConditionalSizeViewState.Option(size: CGSize(width: 200, height: 400), contentState: "vertical"),
            ConditionalSizeViewState.Option(size: CGSize(width: 400, height: 200), contentState: "horizontal")
        ])

        let availableScreenSize = CGSize(width: 200, height: 400)

        XCTAssertEqual(sut.bestOption(for: availableScreenSize)?.contentState, "vertical")
    }

    func testUseHeightAsKingmakerWhenAvailableSpaceIsVertical() {
        let sut = ConditionalSizeViewState(options: [
            ConditionalSizeViewState.Option(size: CGSize(width: 200, height: 400), contentState: "vertical"),
            ConditionalSizeViewState.Option(size: CGSize(width: 400, height: 200), contentState: "horizontal")
        ])

        let availableScreenSize = CGSize(width: 720, height: 1080) // Fits all, screen is vertical, largest height should be taken

        XCTAssertEqual(sut.bestOption(for: availableScreenSize)?.contentState, "vertical")
    }

    func testUseWidthAsKingmakerWhenAvailableSpaceIsHorizontal() {
        let sut = ConditionalSizeViewState(options: [
            ConditionalSizeViewState.Option(size: CGSize(width: 200, height: 400), contentState: "vertical"),
            ConditionalSizeViewState.Option(size: CGSize(width: 400, height: 200), contentState: "horizontal")
        ])

        let availableScreenSize = CGSize(width: 1080, height: 720) // Fits all, screen is horizontal, largest width should be taken

        XCTAssertEqual(sut.bestOption(for: availableScreenSize)?.contentState, "horizontal")
    }

    func testOnOptionsWithSameSizeOnlyOneIsAddedAnyway() {
        let sut = ConditionalSizeViewState(options: [
            ConditionalSizeViewState.Option(size: CGSize(width: 200, height: 400), contentState: "1"),
            ConditionalSizeViewState.Option(size: CGSize(width: 200, height: 400), contentState: "2"),
            ConditionalSizeViewState.Option(size: CGSize(width: 200, height: 400), contentState: "3"),
            ConditionalSizeViewState.Option(size: CGSize(width: 200, height: 400), contentState: "4")
        ])

        let availableScreenSize = CGSize(width: 400, height: 400)

        XCTAssertEqual(sut.options.count, 1)
        XCTAssertEqual(sut.bestOption(for: availableScreenSize)?.contentState, "1")
    }

    func testReturnNilWhenNoMatchBecauseOfWidth() {
        let sut = ConditionalSizeViewState(options: [
            ConditionalSizeViewState.Option(size: CGSize(width: 200, height: 200), contentState: "200"),
            ConditionalSizeViewState.Option(size: CGSize(width: 300, height: 300), contentState: "300"),
            ConditionalSizeViewState.Option(size: CGSize(width: 400, height: 400), contentState: "400"),
            ConditionalSizeViewState.Option(size: CGSize(width: 500, height: 500), contentState: "500"),
            ConditionalSizeViewState.Option(size: CGSize(width: 600, height: 600), contentState: "600")
        ])

        let availableScreenSize = CGSize(width: 199, height: 600)

        XCTAssertNil(sut.bestOption(for: availableScreenSize)?.contentState)
    }

    func testReturnNilWhenNoMatchBecauseOfHeight() {
        let sut = ConditionalSizeViewState(options: [
            ConditionalSizeViewState.Option(size: CGSize(width: 200, height: 200), contentState: "200"),
            ConditionalSizeViewState.Option(size: CGSize(width: 300, height: 300), contentState: "300"),
            ConditionalSizeViewState.Option(size: CGSize(width: 400, height: 400), contentState: "400"),
            ConditionalSizeViewState.Option(size: CGSize(width: 500, height: 500), contentState: "500"),
            ConditionalSizeViewState.Option(size: CGSize(width: 600, height: 600), contentState: "600")
        ])

        let availableScreenSize = CGSize(width: 800, height: 199)

        XCTAssertNil(sut.bestOption(for: availableScreenSize)?.contentState)
    }

    func testReturnNilWhenNoMatchBecauseOfBothDimensions() {
        let sut = ConditionalSizeViewState(options: [
            ConditionalSizeViewState.Option(size: CGSize(width: 200, height: 200), contentState: "200"),
            ConditionalSizeViewState.Option(size: CGSize(width: 300, height: 300), contentState: "300"),
            ConditionalSizeViewState.Option(size: CGSize(width: 400, height: 400), contentState: "400"),
            ConditionalSizeViewState.Option(size: CGSize(width: 500, height: 500), contentState: "500"),
            ConditionalSizeViewState.Option(size: CGSize(width: 600, height: 600), contentState: "600")
        ])

        let availableScreenSize = CGSize(width: 199, height: 199)

        XCTAssertNil(sut.bestOption(for: availableScreenSize)?.contentState)
    }
}

// MARK: Enforcing aspect
extension ConditionalSizeViewTests {
    func testEnforceAspectFitsAllSizesPickTheLargest() {
        let sut = ConditionalSizeViewState(options: [
            ConditionalSizeViewState.Option(size: CGSize(width: 200, height: 300), contentState: "200x300"),
            ConditionalSizeViewState.Option(size: CGSize(width: 300, height: 400), contentState: "300x400"),
            ConditionalSizeViewState.Option(size: CGSize(width: 400, height: 500), contentState: "400x500"),
            ConditionalSizeViewState.Option(size: CGSize(width: 500, height: 600), contentState: "500x600"),
            ConditionalSizeViewState.Option(size: CGSize(width: 600, height: 700), contentState: "600x700")
        ], enforceAspect: true)

        let availableScreenSize = CGSize(width: 800, height: 1080)

        XCTAssertEqual(sut.bestOption(for: availableScreenSize)?.contentState, "600x700")
    }

    func testEnforceAspectFitsAllSizesPickButAspectMismatches() {
        let sut = ConditionalSizeViewState(options: [
            ConditionalSizeViewState.Option(size: CGSize(width: 200, height: 300), contentState: "200x300"),
            ConditionalSizeViewState.Option(size: CGSize(width: 300, height: 400), contentState: "300x400"),
            ConditionalSizeViewState.Option(size: CGSize(width: 400, height: 500), contentState: "400x500"),
            ConditionalSizeViewState.Option(size: CGSize(width: 500, height: 600), contentState: "500x600"),
            ConditionalSizeViewState.Option(size: CGSize(width: 600, height: 700), contentState: "600x700")
        ], enforceAspect: true)

        let availableScreenSize = CGSize(width: 1080, height: 800)

        XCTAssertNil(sut.bestOption(for: availableScreenSize)?.contentState)
    }

    func testEnforceAspectFitsAllSizesPickTheLargestOfDesiredAspect() {
        let sut = ConditionalSizeViewState(options: [
            // vertical
            ConditionalSizeViewState.Option(size: CGSize(width: 200, height: 300), contentState: "200x300"),
            ConditionalSizeViewState.Option(size: CGSize(width: 300, height: 400), contentState: "300x400"),
            ConditionalSizeViewState.Option(size: CGSize(width: 400, height: 500), contentState: "400x500"),
            ConditionalSizeViewState.Option(size: CGSize(width: 500, height: 600), contentState: "500x600"),
            ConditionalSizeViewState.Option(size: CGSize(width: 600, height: 700), contentState: "600x700"),

            // horizontal
            ConditionalSizeViewState.Option(size: CGSize(width: 301, height: 200), contentState: "301x200"),
            ConditionalSizeViewState.Option(size: CGSize(width: 401, height: 300), contentState: "401x300"),
            ConditionalSizeViewState.Option(size: CGSize(width: 501, height: 400), contentState: "501x400"),
            ConditionalSizeViewState.Option(size: CGSize(width: 601, height: 500), contentState: "601x500"),
            ConditionalSizeViewState.Option(size: CGSize(width: 701, height: 600), contentState: "701x600")
        ], enforceAspect: true)

        let availableScreenSize = CGSize(width: 800, height: 1080)

        XCTAssertEqual(sut.bestOption(for: availableScreenSize)?.contentState, "600x700")
    }

    func testNotEnforcingAspectFitsAllSizesPickTheLargestOfAnyAspect() {
        let sut = ConditionalSizeViewState(options: [
            // vertical
            ConditionalSizeViewState.Option(size: CGSize(width: 200, height: 300), contentState: "200x300"),
            ConditionalSizeViewState.Option(size: CGSize(width: 300, height: 400), contentState: "300x400"),
            ConditionalSizeViewState.Option(size: CGSize(width: 400, height: 500), contentState: "400x500"),
            ConditionalSizeViewState.Option(size: CGSize(width: 500, height: 600), contentState: "500x600"),
            ConditionalSizeViewState.Option(size: CGSize(width: 600, height: 700), contentState: "600x700"),

            // horizontal
            ConditionalSizeViewState.Option(size: CGSize(width: 301, height: 200), contentState: "301x200"),
            ConditionalSizeViewState.Option(size: CGSize(width: 401, height: 300), contentState: "401x300"),
            ConditionalSizeViewState.Option(size: CGSize(width: 501, height: 400), contentState: "501x400"),
            ConditionalSizeViewState.Option(size: CGSize(width: 601, height: 500), contentState: "601x500"),
            ConditionalSizeViewState.Option(size: CGSize(width: 701, height: 600), contentState: "701x600")
        ], enforceAspect: false)

        let availableScreenSize = CGSize(width: 800, height: 1080)

        XCTAssertEqual(sut.bestOption(for: availableScreenSize)?.contentState, "701x600")
    }
}
