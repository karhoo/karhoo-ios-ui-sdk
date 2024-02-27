//
//  CheckoutViewModelSpec.swift
//  KarhooUISDKTests
//
//  Created by Aleksander Wedrychowski on 07/02/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Combine
import KarhooSDK
import KarhooUISDKTestUtils
import Nimble
import Quick
import SwiftUI
@testable import KarhooUISDK

class KarhooCheckoutViewModelSpec: QuickSpec {

    override class func spec() {
        describe("Checkout") {

            // MARK: - Helpers

            func buildSut() {
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

            // MARK: - Mocks

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
            var mockTripInfo: TripInfo!
            var mockBasicLoyaltyInfo: KarhooBasicLoyaltyInfo!

            var expectedError: KarhooError!

            beforeEach {
                mockQuoteValidityWorker = MockQuoteValidityWorker()
                mockTripService = MockTripService()
                mockUserService = MockUserService()
                mockAnalytics = MockAnalytics()
                mockSdkConfiguration = KarhooTestConfiguration()
                mockBookingWoker = MockCheckoutBookingWorker()
                mockDateFormatter = MockDateFormatterType()
                mockDateFormatter.displayCustomDateTimeReturnString = "26 JULY 2022"
                mockVehicleRuleProvider = MockVehicleRulesProvider()
                mockCheckoutPassengerDetailsWorker = MockCheckoutPassengerDetailsWorker()
                mockLoyaltyWorker = MockLoyaltyWorker()
                mockCheckoutRouter = MockCheckoutRouter()

                mockQuote = TestUtil.getRandomQuote()
                mockJourneyDetails = TestUtil.getRandomJourneyDetails()
                mockJourneyDetails.scheduledDate = .mock()
                mockBookingMetadata = nil
                mockPassengerDetails = TestUtil.getRandomPassengerDetails()
                mockTripInfo = TestUtil.getRandomTrip()

                mockCheckoutPassengerDetailsWorker.update(passengerDetails: mockPassengerDetails)

                KarhooUI.set(configuration: mockSdkConfiguration)

                buildSut()
            }

            // MARK: - Scene start

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

                it("should send analytics event") {
                    expect(mockAnalytics.checkoutOpenedCalled).to(beTrue())
                }

                it("should have correct initial state") {
                    expect(sut.state).to(equal(.gatheringInfo))
                }

                it("should have journey details data ready to present") {
                    expect(sut.getDateScheduledDescription).to(equal("TUESDAY, 26 JULY 2022"))
                    expect(sut.getPrintedPickUpAddressLine1()).to(equal(mockJourneyDetails.printedPickUpAddressLine1))
                    expect(sut.getPrintedPickUpAddressLine2()).to(equal(mockJourneyDetails.printedPickUpAddressLine2))
                    expect(sut.getPrintedDropOffAddressLine1()).to(equal(mockJourneyDetails.printedDropOffAddressLine1))
                    expect(sut.getPrintedDropOffAddressLine2()).to(equal(mockJourneyDetails.printedDropOffAddressLine2))
                }

                it("should set quote validity deadline") {
                    expect(mockQuoteValidityWorker.setQuoteValidityDeadlineCalled).to(beTrue())
                }

                // MARK: - showing train and flight cells

                it("should not show flight cell") {
                    expect(sut.showFlightNumberCell).to(beFalse())
                }

                it("should not show train cell") {
                    expect(sut.showTrainNumberCell).to(beFalse())
                }

                context("and when jouney is asap") {
                    beforeEach {
                        mockJourneyDetails.scheduledDate = nil
                    }

                    it("should not show train cell") {
                        expect(sut.showTrainNumberCell).to(beFalse())
                    }

                    it("should not show flight cell") {
                        expect(sut.showFlightNumberCell).to(beFalse())
                    }
                }

                context("and when all requirements for showing the flight cell are met") {
                    beforeEach {
                        mockJourneyDetails.originLocationDetails = TestUtil.getRandomLocationInfo(poiDetails: .init(iata: "qwe", terminal: "rty", type: .airport))
                        mockJourneyDetails.scheduledDate = Date().addingTimeInterval(30000)
                        mockQuote = TestUtil.getRandomQuote(fleetCapability: ["flight_tracking"])
                        buildSut()
                    }

                    it("should show flight cell") {
                        expect(sut.showFlightNumberCell).to(beTrue())
                    }

                    it("should not show train cell") {
                        expect(sut.showTrainNumberCell).to(beFalse())
                    }
                }

                context("and when all requirements for showing the train cell are met") {
                    beforeEach {
                        mockJourneyDetails.originLocationDetails = TestUtil.getRandomLocationInfo(poiDetails: .init(iata: "qwe", terminal: "rty", type: .trainStation))
                        mockJourneyDetails.scheduledDate = Date().addingTimeInterval(30000)
                        mockQuote = TestUtil.getRandomQuote(fleetCapability: ["train_tracking"])
                        buildSut()
                    }

                    it("should not show flight cell") {
                        expect(sut.showFlightNumberCell).to(beFalse())
                    }

                    it("should show train cell") {
                        expect(sut.showTrainNumberCell).to(beTrue())
                    }
                }
                context("and when jouney details") {

                }

                context("and when quote validity deadline is reached") {
                    beforeEach {
                        mockQuoteValidityWorker.setQuoteValidityDeadlineReceivedArguments?.deadlineCompletion()
                    }
                    it("should show quote expired error") {
                        expect(sut.showError).to(beTrue())
                        expect(sut.quoteExpired).to(beTrue())
                    }
                }

                // MARK: - Passenger data and required data validation

                context("and when there is no passengerDetails set") {
                    beforeEach {
                        mockCheckoutPassengerDetailsWorker.update(passengerDetails: nil)
                        sut.onAppear()
                    }

                    context("and when confirm button is tapped") {
                        beforeEach {
                            sut.didTapConfirm()
                        }

                        it("should navigate to passenger details screen") {
                            expect(mockCheckoutRouter.routeToPassengerDetailsCalled?.currentDetails).to(beNil())
                        }
                    }
                }

                context("and when there is a valid passengerDetails object set") {
                    beforeEach {
                        mockPassengerDetails = TestUtil.getRandomValidPassengerDetails()
                        mockCheckoutPassengerDetailsWorker.update(passengerDetails: mockPassengerDetails)
                        sut.onAppear()
                    }

                    context("and when terms and conditions approval is not required") {
                        beforeEach {
                            KarhooTestConfiguration.isExplicitTermsAndConditionsConsentRequired = false
                            buildSut()
                            sut.onAppear()
                        }

                        context("and when confirm button is tapped") {
                            beforeEach {
                                sut.didTapConfirm()
                            }

                            it("should start booking") {
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

                                it("should start booking") {
                                    expect(mockBookingWoker.performBookingCalled).to(beTrue())
                                }
                            }
                        }
                    }
                }

                // MARK: - Loyalty

                context("and when loyalty is enabled") {
                    beforeEach {
                        mockLoyaltyWorker.isLoyaltyEnabled = true
                        mockLoyaltyUIModel = LoyaltyUIModel(loyaltyId: "qw", currency: "er", tripAmount: 42, canEarn: true, canBurn: true, burnAmount: 24, earnAmount: 10, balance: 100)
                        mockLoyaltyWorker.modelSubject.send(.success(
                            result: mockLoyaltyUIModel,
                            correlationId: ""
                        ))
                        mockBasicLoyaltyInfo = .init(
                            shouldShowLoyalty: true,
                            loyaltyPoints: 10,
                            loyaltyMode: .earn
                        )
                        mockLoyaltyWorker.getBasicLoyaltyInfoToReturn = mockBasicLoyaltyInfo
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
                    
                    context("and when booking state is changed to .success") {
                        beforeEach {
                            mockBookingWoker.stateSubject.send(.success(mockTripInfo))
                        }
                        
                        it ("should pass correct data to router success scene") {
                            expect(mockCheckoutRouter.routeSuccessSceneCalledData?.loyaltyInfo.shouldShowLoyalty).to(equal(mockLoyaltyWorker.isLoyaltyEnabled))
                            expect(mockCheckoutRouter.routeSuccessSceneCalledData?.loyaltyInfo.loyaltyPoints).to(equal(mockBasicLoyaltyInfo.loyaltyPoints))
                            expect(mockCheckoutRouter.routeSuccessSceneCalledData?.loyaltyInfo.loyaltyMode).to(equal(LoyaltyMode.earn))
                            
                        }
                    }
                    context("and when is switched to burn mode") {
                        beforeEach {
                            sut.loyaltyViewModel.isBurnModeOn = true
                            mockBasicLoyaltyInfo = .init(
                                shouldShowLoyalty: true,
                                loyaltyPoints: 10,
                                loyaltyMode: .burn
                            )
                            mockLoyaltyWorker.getBasicLoyaltyInfoToReturn = mockBasicLoyaltyInfo
                        }
                        context("and when booking state is changed to .success") {
                            beforeEach {
                                mockBookingWoker.stateSubject.send(.success(mockTripInfo))
                            }
                            
                            it ("should pass correct data to router success scene") {
                                expect(mockCheckoutRouter.routeSuccessSceneCalledData?.loyaltyInfo.shouldShowLoyalty).to(equal(mockLoyaltyWorker.isLoyaltyEnabled))
                                expect(mockCheckoutRouter.routeSuccessSceneCalledData?.loyaltyInfo.loyaltyPoints).to(equal(mockBasicLoyaltyInfo.loyaltyPoints))
                                expect(mockCheckoutRouter.routeSuccessSceneCalledData?.loyaltyInfo.loyaltyMode).to(equal(LoyaltyMode.burn))
                                
                            }
                        }
                    }

                    context("and when there is a loyalty insufficientBalance error") {
                        beforeEach {
                            mockLoyaltyWorker.modelSubject.send(.failure(error: KarhooLoyaltyError.insufficientBalance, correlationId: "42"))
                        }

                        it("should set proper data state") {
                            expect(sut.loyaltyViewModel.error).to(beNil())
                            expect(sut.loyaltyViewModel.burnSectionDisabled).to(beTrue())
                            expect(sut.loyaltyViewModel.burnOffSubtitle).to(equal(UITexts.Errors.insufficientBalanceForLoyaltyBurning))
                        }
                    }
                    context("and when there is a loyalty error") {
                        beforeEach {
                            mockLoyaltyWorker.modelSubject.send(.failure(error: KarhooLoyaltyError.unknownError, correlationId: "42"))
                        }

                        it("should set proper data state") {
                            expect(sut.loyaltyViewModel.error).to(equal(KarhooLoyaltyError.unknownError))
                            expect(sut.loyaltyViewModel.burnSectionDisabled).to(beFalse())
                        }
                    }
                }

                // MARK: - Booking state handling

                context("and when booking state is changed to .idle") {
                    beforeEach {
                        mockBookingWoker.stateSubject.send(.idle)
                    }

                    context("and all required data are in place") {
                        beforeEach {
                            mockPassengerDetails = TestUtil.getRandomValidPassengerDetails()
                            mockCheckoutPassengerDetailsWorker.update(passengerDetails: mockPassengerDetails)
                            KarhooTestConfiguration.isExplicitTermsAndConditionsConsentRequired = true
                            sut.termsConditionsViewModel.confirmed.send(true)
                        }

                        it("should set checkout state to .readyToBook") {
                            expect(sut.state).to(equal(.readyToBook))
                        }

                        it("should set confirm button title to `PAY`") {
                            expect(sut.confirmButtonTitle).to(equal("PAY"))
                        }
                    }

                    context("and not all required data are in place") {
                        beforeEach {
                            KarhooTestConfiguration.isExplicitTermsAndConditionsConsentRequired = true
                            sut.termsConditionsViewModel.confirmed.send(false)
                        }

                        it("should set checkout state to .readyToBook") {
                            expect(sut.state).to(equal(.gatheringInfo))
                        }

                        it("should set confirm button title to `NEXT`") {
                            expect(sut.confirmButtonTitle).to(equal("NEXT"))
                        }
                    }
                }

                context("and when booking state is changed to .loading") {
                    // No handling there
                }

                context("and when booking state is changed to .failure") {
                    beforeEach {
                        expectedError = ErrorModel(message: "xyz", code: "cvb")
                        mockBookingWoker.stateSubject.send(.failure(expectedError))
                    }

                    it("should set checkout state to error") {
                        expect(sut.state).to(equal(.error(
                            title: UITexts.Generic.error,
                            message: expectedError.localizedMessage
                        )))
                    }
                }

                context("and when booking state is changed to .success") {
                    beforeEach {
                        mockBookingWoker.stateSubject.send(.success(mockTripInfo))
                    }

                    it("should invalidate quote validity worker") {
                        expect(mockQuoteValidityWorker.invalidateCalled).to(beTrue())
                    }

                    it("should proceed to success scene") {
                        expect(mockCheckoutRouter.routeSuccessSceneCalled).to(beTrue())
                    }
                }
            }
        }
    }
}
