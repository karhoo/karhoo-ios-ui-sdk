//
//  KarhooNewCheckoutViewModelSpec.swift
//  KarhooUISDKTests
//
//  Created by Aleksander Wedrychowski on 03/02/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import Quick
import Nimble
import KarhooSDK
import KarhooUISDKTestUtils

@testable import KarhooUISDK

class KarhooNewCheckoutViewModelSpec: QuickSpec {
    
    override func spec() {
        // MARK: - Test object
        var sut: KarhooNewCheckoutViewModel!
        
        // MARK: - Test dependencies
        var mockTripService: MockTripService!
        var mockUserService: MockUserService!
        var mockAnalytics: MockAnalytics!
        var mockSdkConfiguration: MockSDKConfig!
        var mockBookingWorker: MockBookingWorker!
        var mockDateFormatter: MockDateFormatter!
        var mockVehicleRuleProvider: MockVehicleRuleProvider!
        var mockPassengerDetailsWorker: MockPassengerDetailsWorker!
        var mockQuoteValidityWorker: MockQuoteValidityWorker!

        // MARK: - Mocked sub-view models
        var mockPassengerDetailsViewModel: MockPassengerDetailsViewModel!
        var mockTrainNumberViewModel: MockTrainNumberViewModel!
        var mockFlightNumberViewModel: MockFlightNumberViewModel!
        var mockCommentsViewModel: MockCommentsViewModel!
        var mockTermsConditionsViewModel: MockTermsConditionsViewModel!
        var mockLegalViewModel: MockLegalViewModel!
        var mockLoyaltyViewModel: MockLoyaltyViewModel!
        
        var mockRouter: MockCheckoutRouter!
        
        // MARK: - Test initial data
        var mockQuote: Quote!
        var mockJourneyDetails: JourneyDetails!
        var mockBookingMetadata: [String: Any]?
        
        // MARK: - Test setup
        beforeEach {
            mockTripService = MockTripService()
            mockUserService = MockUserService()
            mockAnalyticsService = MockAnalyticsService()
            mockSdkConfiguration = MockSDKConfig()
            mockBookingWorker = MockBookingWorker()
            mockDateFormatter = MockDateFormatter()
            mockVehicleRuleProvider = MockVehicleRuleProvider()
            mockPassengerDetailsWorker = MockPassengerDetailsWorker()
            mockRouter = MockCheckoutRouter()
            
            mockQuote = TestUtil.getRandomQuote()
            mockJourneyDetails = TestUtil.getRandomJourneyDetails()
            
            mockPassengerDetailsViewModel = MockPassengerDetailsViewModel()
            mockTrainNumberViewModel = MockTrainNumberViewModel()
            mockFlightNumberViewModel = MockFlightNumberViewModel()
            mockCommentsViewModel = MockCommentsViewModel()
            mockTermsConditionsViewModel = MockTermsConditionsViewModel()
            mockLegalViewModel = MockLegalViewModel()
            mockLoyaltyViewModel = MockLoyaltyViewModel()
            
            sut = KarhooNewCheckoutViewModel(
                quote: mockQuote,
                journeyDetails: mockJourneyDetails,
                bookingMetadata: mockBookingMetadata,
                tripService: mockTripService,
                userService: mockUserService,
                analyticsService: mockAnalyticsService,
                sdkConfig: mockSdkConfiguration,
                bookingWorker: mockBookingWorker,
                dateFormatter: mockDateFormatter,
                vehicleRuleProvider: mockVehicleRuleProvider,
                passengerDetailsWorker: mockPassengerDetailsWorker,
                router: mockRouter,
                passengerDetailsViewModel: mockPassengerDetailsViewModel,
                trainNumberViewModel: mockTrainNumberViewModel,
                flightNumberViewModel: mockFlightNumberViewModel,
                commentsViewModel: mockCommentsViewModel,
                termsConditionsViewModel: mockTermsConditionsViewModel,
                legalViewModel: mockLegalViewModel,
                loyaltyViewModel: mockLoyaltyViewModel
            )
        }

        // MARK: - Tests

        context("when onAppear is called") {
            beforeEach {
                sut.onAppear()
            }

            it("state is set to loading") {
                expect(sut.state).to(equal(NewCheckoutState.gatheringInfo))
            }

            it("quoteValidity deadline is set") {
                expect(mockQuoteValidityWorker.setQuoteValidityDeadlineCalled).to(beTrue())
            }

            it("analytics event is sent") {
                expect(mockAnalytics.checkoutOpenedCalled).to(beTrue())
            }

            it("analytics event is sent with correct quote type") {
                expect(mockAnalytics.checkoutOpenedQuoteType).to(equal(mockQuote.quoteType))
            }

            it("analytics event is sent with correct quote id") {
                expect(mockAnalytics.checkoutOpenedQuoteId).to(equal(mockQuote.quoteId))
            }
        }
    }
}
