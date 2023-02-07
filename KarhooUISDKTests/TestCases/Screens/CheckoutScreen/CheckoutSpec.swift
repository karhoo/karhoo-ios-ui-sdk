//
//  CheckoutSpec.swift
//  KarhooUISDKTests
//
//  Created by Aleksander Wedrychowski on 07/02/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Combine
import Quick
import Nimble
import SnapshotTesting
import SwiftUI
import KarhooSDK
import KarhooUISDKTestUtils
@testable import KarhooUISDK

class ChackoutSpec: QuickSpec {

    override func spec() {
        describe("Checkout") {
            var sut: KarhooCheckoutViewModel!
            var mockQuoteValidityWorker: MockQuoteValidityWorker!
            var mockTripService: MockTripService!
            var mockUserService: MockUserService!
            var mockAnalytics: MockAnalytics!
            var mockSdkConfiguration: KarhooTestConfiguration!
            var mockBookingWoker: MockCheckoutBookingWorker!
            var mockDateFormatter: MockDateFormatterType!
            var mockVehicleRuleProvider: MockVehicleRulesProvider!
            var mockCheckoutPassengerDetailsWorker: MockCheckoutPassengerDetailsWorker!
            var mockLoyaltyWorker: MockLoyaltyWorker!
            var mockCheckoutRouter: MockCheckoutRouter!

            var mockQuote: Quote!
            var mockJourneyDetails: JourneyDetails!
            var mockBookingMetadata: [String: Any]?
            var mockPassengerDetails: PassengerDetails!
            var mockLoyaltyUIModel: LoyaltyUIModel!

            beforeEach {
                mockQuoteValidityWorker = MockQuoteValidityWorker()
                mockTripService = MockTripService()
                mockUserService = MockUserService()
                mockAnalytics = MockAnalytics()
                mockSdkConfiguration = KarhooTestConfiguration()
                mockBookingWoker = MockCheckoutBookingWorker()
                mockDateFormatter = MockDateFormatterType()
                mockVehicleRuleProvider = MockVehicleRulesProvider()
                mockCheckoutPassengerDetailsWorker = MockCheckoutPassengerDetailsWorker()
                mockLoyaltyWorker = MockLoyaltyWorker()
                mockCheckoutRouter = MockCheckoutRouter()

                mockQuote = TestUtil.getRandomQuote()
                mockJourneyDetails = TestUtil.getRandomJourneyDetails()
                mockJourneyDetails.scheduledDate = .mock()
                mockBookingMetadata = nil
                mockPassengerDetails = TestUtil.getRandomPassengerDetails()

                mockCheckoutPassengerDetailsWorker.update(passengerDetails: mockPassengerDetails)

                KarhooUI.set(configuration: mockSdkConfiguration)

                sut = KarhooCheckoutViewModel(
                    quote: mockQuote,
                    journeyDetails: mockJourneyDetails,
                    bookingMetadata: mockBookingMetadata,
                    quoteValidityWorker: mockQuoteValidityWorker,
                    tripService: mockTripService,
                    userService: mockUserService,
                    passengerDetails: mockPassengerDetails,
                    analytics: mockAnalytics,
                    sdkConfiguration: mockSdkConfiguration,
                    dateFormatter: mockDateFormatter,
                    vehicleRuleProvider: mockVehicleRuleProvider,
                    bookingWorkerClosure: { _, _, _ in mockBookingWoker },
                    passengerDetailsWorkerClosure: { _ in mockCheckoutPassengerDetailsWorker },
                    loyaltyWorker: mockLoyaltyWorker,
                    router: mockCheckoutRouter
                )
            }

            context("when view model is initialised") {

                it("should have correct initial state") {
                    expect(sut.state).to(equal(.gatheringInfo))
                }

                it("should call for vehicle image url") {
                    expect(mockVehicleRuleProvider.getRuleCalled).to(beTrue())
                }
            }

            context("when onAppear is called") {
                beforeEach {
                    sut.onAppear()
                }

                it("should update vehicle rules") {
                    expect(mockVehicleRuleProvider.updateCalled).to(beTrue())
                }

                it("should send analytics event") {
                    expect(mockAnalytics.checkoutOpenedCalled).to(beTrue())
                }

                it("should have correct initial state") {
                    expect(sut.state).to(equal(.gatheringInfo))
                }

                it("should have journey details data ready to present") {
                    expect(sut.getDateScheduledDescription).to(equal(""))
                    expect(sut.getPrintedPickUpAddressLine1()).to(equal(mockJourneyDetails.printedPickUpAddressLine1))
                    expect(sut.getPrintedPickUpAddressLine2()).to(equal(mockJourneyDetails.printedPickUpAddressLine2))
                    expect(sut.getPrintedDropOffAddressLine1()).to(equal(mockJourneyDetails.printedDropOffAddressLine1))
                    expect(sut.getPrintedDropOffAddressLine2()).to(equal(mockJourneyDetails.printedDropOffAddressLine2))
                }
            }

            context("when there is no passengerDetails set") {
                beforeEach {
                    mockCheckoutPassengerDetailsWorker.update(passengerDetails: nil)
                    sut.onAppear()
                }

                context("and when confirm button is tapped") {
                    beforeEach {
                        sut.didTapConfirm()
                    }

                    it("should navigate to passenger details screen") {
                        expect(mockCheckoutRouter.routeToPassengerDetailsCalled?.currentDetails).to(equal(mockPassengerDetails))
                    }
                }
            }

            context("when there is passengerDetails set") {
                beforeEach {
                    mockCheckoutPassengerDetailsWorker.update(passengerDetails: mockPassengerDetails)
                    sut.onAppear()
                }

                context("and when terms and conditions approval is not required") {
                    beforeEach {
                        KarhooTestConfiguration.isExplicitTermsAndConditionsConsentRequired = false
                        sut.onAppear()
                    }

                    context("and when confirm button is tapped") {
                        beforeEach {
                            sut.didTapConfirm()
                        }

                        it("should show T&C required") {
                            expect(mockBookingWoker.performBookingCalled).to(beTrue())
                        }
                    }
                }

                context("and when terms and conditions approval is required") {
                    beforeEach {
                        KarhooTestConfiguration.isExplicitTermsAndConditionsConsentRequired = true
                        sut.onAppear()
                    }

                    context("and terms and conditions is not confirmend") {
                        context("and when confirm button is tapped") {
                            beforeEach {
                                sut.didTapConfirm()
                            }

                            it("should show T&C required") {
                                expect(sut.showError).to(beTrue())
                                expect(sut.scrollToTermsConditions).to(beTrue())
                                expect(sut.termsConditionsViewModel.showAgreementRequired).to(beTrue())
                            }
                        }
                    }

                    context("and terms and conditions field is confirmed") {
                        beforeEach {
                            sut.termsConditionsViewModel.confirmed.send(true)
                        }

                        context("and when confirm button is tapped") {
                            beforeEach {
                                sut.didTapConfirm()
                            }

                            it("should show T&C required") {
                                expect(mockBookingWoker.performBookingCalled).to(beTrue())
                            }
                        }
                    }
                }
            }

            context("when loyalty is enabled") {
                beforeEach {
                    mockLoyaltyWorker.isLoyaltyEnabled = true
                    mockLoyaltyUIModel = LoyaltyUIModel(loyaltyId: "qw", currency: "er", tripAmount: 42, canEarn: true, canBurn: true, burnAmount: 24, earnAmount: 10, balance: 100)
                    mockLoyaltyWorker.modelSubject.send(.success(
                        result: mockLoyaltyUIModel,
                        correlationId: ""
                    ))
                }

                it("show have proper Loyalty data to present") {
                    expect(sut.loyaltyViewModel.canEarn).to(equal(mockLoyaltyUIModel.canEarn))
                    expect(sut.loyaltyViewModel.earnAmount).to(equal(mockLoyaltyUIModel.earnAmount))
                    expect(sut.loyaltyViewModel.balance).to(equal(mockLoyaltyUIModel.balance))
                    expect(sut.loyaltyViewModel.burnSectionDisabled).to(beFalse())
                    expect(sut.loyaltyViewModel.canBurn).to(equal(mockLoyaltyUIModel.canBurn))
                    expect(sut.loyaltyViewModel.currency).to(equal(mockLoyaltyUIModel.currency))
                    expect(sut.loyaltyViewModel.tripAmount).to(equal(mockLoyaltyUIModel.tripAmount))
                    expect(sut.loyaltyViewModel.burnAmount).to(equal(mockLoyaltyUIModel.burnAmount))
                }

                context("and when there is a loyalty insufficientBalance error") {
                    beforeEach {
                        mockLoyaltyWorker.modelSubject.send(.failure(error: KarhooLoyaltyError.insufficientBalance, correlationId: "42"))
                    }

                    it("should set proper data state") {
                        expect(sut.loyaltyViewModel.error).to(equal(LoyaltyError.insufficientBalance))
                        expect(sut.loyaltyViewModel.burnSectionDisabled).to(beTrue())
                        expect(sut.loyaltyViewModel.burnOffSubtitle).to(equal(UITexts.Errors.insufficientBalanceForLoyaltyBurning))
                    }
                }
                context("and when there is a loyalty error") {
                    beforeEach {
                        mockLoyaltyWorker.modelSubject.send(.failure(error: KarhooLoyaltyError.unknownError, correlationId: "42"))
                    }

                    it("should set proper data state") {
                        expect(sut.loyaltyViewModel.error).to(equal(LoyaltyError.unknownError))
                        expect(sut.loyaltyViewModel.burnSectionDisabled).to(beFalse())
                    }
                }
            }
        }
    }

    // MARK: - Helpers
}
