//
//  QuoteListSnapshotSpec.swift
//  KarhooUISDKTests
//
//  Created by Aleksander Wedrychowski on 17/10/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Quick
import Nimble
import SnapshotTesting
import KarhooSDK

@testable import KarhooUISDK

class QuoteListSnapshotSpec: QuickSpec {

    override func spec() {
        describe("QuoteList") {

            var navigationController: NavigationController!
            var sut: KarhooQuoteListViewController!
            var presenterMock: MockQuoteListPresenter!

            beforeEach {
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

    override func spec() {
        describe("QuoteList") {

            var navigationController: NavigationController!
            var sut: KarhooQuoteListViewController!
            var presenterMock: MockQuoteListPresenter!

            beforeEach {
                let mockVC = MockViewController().then {
                    $0.loadViewIfNeeded()
                }
                navigationController = NavigationController(rootViewController: mockVC, style: .primary)
                sut = KarhooQuoteListViewController()
                presenterMock = MockQuoteListPresenter()
                sut.setupBinding(presenterMock)
                navigationController.pushViewController(sut, animated: false)
            }

            context("when journey details are set") {
                beforeEach {
                    let journey = JourneyInfo.mock()
                    KarhooJourneyDetailsManager.shared.setJourneyInfo(journeyInfo: journey)
                }

                context("and when quotes are loaded") {
                    beforeEach {
                        presenterMock.onStateUpdated?(.fetched(quotes: [.mock(), .mock2(), .mock(), .mock2()]))
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

                context("and when there is no available services") {
                    beforeEach {
                        presenterMock.onStateUpdated?(.empty(reason: .noAvailabilityInRequestedArea))
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
}