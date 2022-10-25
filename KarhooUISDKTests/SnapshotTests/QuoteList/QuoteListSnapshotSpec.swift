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

    var navigationController: NavigationController!
    var sut: KarhooQuoteListViewController!
    var coordinator: KarhooQuoteListCoordinator!
    var presenterMock: MockQuoteListPresenter!
    var mockQuoteService: MockQuoteService!

    override func spec() {
        describe("QuoteList") {

            beforeEach {
                let mockVC = MockViewController().then {
                    $0.loadViewIfNeeded()
                }
                self.navigationController = NavigationController(rootViewController: mockVC, style: .primary)
                self.sut = KarhooQuoteListViewController()
                self.presenterMock = MockQuoteListPresenter()
                self.sut.setupBinding(self.presenterMock)
                self.navigationController.pushViewController(self.sut, animated: false)
            }

            context("when journey details are set") {
                beforeEach {
                    let journey = JourneyInfo.mock()
                    KarhooJourneyDetailsManager.shared.setJourneyInfo(journeyInfo: journey)
                }

                context("when the view is opened") {

                    it("should have valid design for loading state") {
                        testSnapshot(self.navigationController)
                    }
                }

                context("when quotes are loaded") {
                    beforeEach {
                        self.presenterMock.onStateUpdated?(.fetched(quotes: [.mock(), .mock2(), .mock(), .mock2()]))
                    }

                    context("and when sorting is available") {

                        beforeEach {
                            self.presenterMock.isSortingAvailableToReturn = true
                        }

                        it("should have valid design") {
                            testSnapshot(self.navigationController)
                        }
                    }

                    context("and when sorting is available") {

                        beforeEach {
                            self.presenterMock.isSortingAvailableToReturn = true
                        }

                        it("should have valid design") {
                            assertSnapshot(
                                matching: self.navigationController,
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
}

extension Quote {
    static func mock(quoteType: QuoteType = .estimated, vehicleType: String = "standard") -> Quote {
        Quote(
            id: UUID().uuidString,
            quoteType: quoteType,
            source: .fleet,
            pickUpType: .default,
            fleet: .init(id: UUID().uuidString, name: "Mocked Fleet"),
            vehicle: QuoteVehicle(
                vehicleClass: vehicleType,
                type: vehicleType,
                tags: ["wheelchair", "child-seat"],
                qta: QuoteQta(highMinutes: 10, lowMinutes: 5),
                passengerCapacity: 4,
                luggageCapacity: 4
            ),
            price: QuotePrice(highPrice: 10.0, lowPrice: 8.0, currencyCode: "EUR"),
            validity: 30,
            serviceLevelAgreements: ServiceAgreements(
                serviceCancellation: .init(type: .timeBeforePickup, minutes: 5),
                serviceWaiting: .init(minutes: 5)
            )
        )
    }

    static func mock2(quoteType: QuoteType = .fixed, vehicleType: String = "mpv") -> Quote {
        Quote(
            id: UUID().uuidString,
            quoteType: quoteType,
            source: .fleet,
            pickUpType: .default,
            fleet: .init(id: UUID().uuidString, name: "Mocked Fleet"),
            vehicle: QuoteVehicle(
                vehicleClass: vehicleType,
                type: vehicleType,
                tags: ["wheelchair", "child-seat"],
                qta: QuoteQta(highMinutes: 10, lowMinutes: 5),
                passengerCapacity: 4,
                luggageCapacity: 4
            ),
            price: QuotePrice(highPrice: 10.0, lowPrice: 8.0, currencyCode: "EUR"),
            validity: 30,
            serviceLevelAgreements: ServiceAgreements(
                serviceCancellation: .init(type: .timeBeforePickup, minutes: 5),
                serviceWaiting: .init(minutes: 5)
            )
        )
    }
}
