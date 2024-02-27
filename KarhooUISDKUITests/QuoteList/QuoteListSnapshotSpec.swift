//
//  QuoteListSnapshotSpec.swift
//  KarhooUISDKUITests
//
//  Created by Aleksander Wedrychowski on 04/11/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import KarhooSDK
import KarhooUISDKTestUtils
import Nimble
import Quick
import SnapshotTesting
@testable import KarhooUISDK

class QuoteListSnapshotSpec: QuickSpec {

    override class func spec() {
        describe("QuoteList") {

            var navigationController: NavigationController!
            var sut: KarhooQuoteListViewController!
            var presenterMock: MockQuoteListPresenter!

            beforeEach {
                KarhooUI.set(configuration: KarhooTestConfiguration())
                let journey = JourneyInfo.mock()
                KarhooJourneyDetailsManager.shared.setJourneyInfo(journeyInfo: journey)

                let mockVC = MockViewController().then {
                    $0.loadViewIfNeeded()
                }
                navigationController = NavigationController(rootViewController: mockVC, style: .primary)
                sut = KarhooQuoteListViewController()
                presenterMock = MockQuoteListPresenter()
                sut.setupBinding(presenterMock)
                navigationController.pushViewController(sut, animated: false)
            }

            context("when the view is opened") {

                it("should have valid design") {
                    testSnapshot(navigationController)
                }
            }

            context("when journey details are set") {
                beforeEach {
                    let journey = JourneyInfo.mock()
                    KarhooJourneyDetailsManager.shared.setJourneyInfo(journeyInfo: journey)
                }

                context("and when the view is opened") {

                    it("should have valid design for loading state") {
                        testSnapshot(navigationController)
                    }
                }

                context("and when sorting is available") {
                    beforeEach {
                        presenterMock.isSortingAvailableToReturn = true

                    }

                    context("and when quotes are loaded") {
                        beforeEach {
                            presenterMock.onStateUpdated?(.fetched(quotes: [.mock(), .mock2(), .mock(), .mock2()]))
                        }

                        it("should have valid design") {
                            testSnapshot(navigationController)
                        }
                    }
                }

                context("and when sorting is not available") {
                    beforeEach {
                        presenterMock.isSortingAvailableToReturn = false
                    }

                    context("and when quotes are loaded") {

                        beforeEach {
                            presenterMock.onStateUpdated?(.fetched(quotes: [.mock(), .mock2(), .mock(), .mock2()]))
                        }

                        it("should have valid design") {
                            testSnapshot(navigationController)
                        }
                    }
                }
            }
        }
    }
}

class QuoteListAsyncSnapshotSpec: QuickSpec {

    override class func spec() {
        describe("QuoteList") {

            var navigationController: NavigationController!
            var sut: KarhooQuoteListViewController!
            var presenterMock: MockQuoteListPresenter!

            beforeEach {
                KarhooUI.set(configuration: KarhooTestConfiguration())
                let mockVC = MockViewController().then {
                    $0.loadViewIfNeeded()
                }
                navigationController = NavigationController(rootViewController: mockVC, style: .primary)
                sut = KarhooQuoteListViewController()
                presenterMock = MockQuoteListPresenter()
                sut.setupBinding(presenterMock)
                navigationController.pushViewController(sut, animated: false)
            }

            context("and when quotes are loaded") {
                beforeEach {
                    presenterMock.onStateUpdated?(.fetched(quotes: [.mock(), .mock2(), .mock(), .mock2()]))
                }

                it("should have valid design") {
                    assertSnapshot(
                        matching: navigationController,
                        as: .wait(
                            for: 3,
                            on: .image(on: .iPhoneX)
                        ),
                        named: QuickSpec.current.name
                    )
                }
            }

            context("and when there is no available services") {
                beforeEach {
                    presenterMock.onStateUpdated?(.empty(reason: .noAvailabilityInRequestedArea(isPrebook: false)))
                }

                it("should have valid design") {
                    assertSnapshot(
                        matching: navigationController,
                        as: .wait(
                            for: 1,
                            on: .image(on: .iPhoneX)
                        ),
                        named: QuickSpec.current.name
                    )
                }
            }

            context("and destination or origin are too similar") {
                beforeEach {
                    presenterMock.onStateUpdated?(.empty(reason: .destinationOrOriginEmpty))
                }

                it("should have valid design") {
                    assertSnapshot(
                        matching: navigationController,
                        as: .wait(
                            for: 1,
                            on: .image(on: .iPhoneX)
                        ),
                        named: QuickSpec.current.name
                    )
                }
            }

            context("and there are no results for given filters") {
                beforeEach {
                    presenterMock.onStateUpdated?(.empty(reason: .noQuotesAfterFiltering))
                }

                it("should have valid design") {
                    assertSnapshot(
                        matching: navigationController,
                        as: .wait(
                            for: 1,
                            on: .image(on: .iPhoneX)
                        ),
                        named: QuickSpec.current.name
                    )
                }
            }

            context("and there are no results for given ride parameters") {
                beforeEach {
                    presenterMock.onStateUpdated?(.empty(reason: .noQuotesForSelectedParameters))
                }

                it("should have valid design") {
                    assertSnapshot(
                        matching: navigationController,
                        as: .wait(
                            for: 1,
                            on: .image(on: .iPhoneX)
                        ),
                        named: QuickSpec.current.name
                    )
                }
            }
        }
    }
}
