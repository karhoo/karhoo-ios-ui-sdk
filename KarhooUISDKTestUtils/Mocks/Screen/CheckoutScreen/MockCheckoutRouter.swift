//
//  MockCheckoutRouter.swift
//  KarhooUISDKTestUtils
//
//  Created by Aleksander Wedrychowski on 03/02/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import KarhooSDK
@testable import KarhooUISDK

class MockCheckoutRouter: NewCheckoutRouter {
    var routeToPriceDetailsCalled = false
    var routeToPriceDetailsTitle: String?
    var routeToPriceDetailsQuoteType: QuoteType?
    func routeToPriceDetails(title: String, quoteType: QuoteType) {
        routeToPriceDetailsCalled = true
        routeToPriceDetailsTitle = title
        routeToPriceDetailsQuoteType = quoteType
    }

    var routeToFlightNumberCalled = false
    var routeToFlightNumberTitle: String?
    var routeToFlightNumberFlightNumber: String?
    func routeToFlightNumber(title: String, flightNumber: String) {
        routeToFlightNumberCalled = true
        routeToFlightNumberTitle = title
        routeToFlightNumberFlightNumber = flightNumber
    }

    var routeToTrainNumberCalled = false
    var routeToTrainNumberTitle: String?
    var routeToTrainNumberTrainNumber: String?
    func routeToTrainNumber(title: String, trainNumber: String) {
        routeToTrainNumberCalled = true
        routeToTrainNumberTitle = title
        routeToTrainNumberTrainNumber = trainNumber
    }

    var routeToCommentCalled = false
    var routeToCommentTitle: String?
    var routeToCommentComments: String?
    func routeToComment(title: String, comments: String) {
        routeToCommentCalled = true
        routeToCommentTitle = title
        routeToCommentComments = comments
    }

    var routeToPassengerDetailsCalled = false
    var routeToPassengerDetailsCurrentDetails: PassengerDetails?
    var routeToPassengerDetailsDelegate: PassengerDetailsDelegate?
    func routeToPassengerDetails(
        _ currentDetails: PassengerDetails?,
        delegate: PassengerDetailsDelegate?
    ) {
        routeToPassengerDetailsCalled = true
        routeToPassengerDetailsCurrentDetails = currentDetails
        routeToPassengerDetailsDelegate = delegate
    }

    var routeSuccessSceneCalled = false
    var routeSuccessSceneTripInfo: TripInfo?
    var routeSuccessSceneJourneyDetails: JourneyDetails?
    var routeSuccessSceneQuote: Quote?
    var routeSuccessSceneLoyaltyInfo: KarhooBasicLoyaltyInfo?
    func routeSuccessScene(
        with tripInfo: TripInfo,
        journeyDetails: JourneyDetails?,
        quote: Quote,
        loyaltyInfo: KarhooBasic
    ) {
        routeSuccessSceneCalled = true
        routeSuccessSceneTripInfo = tripInfo
        routeSuccessSceneJourneyDetails = journeyDetails
        routeSuccessSceneQuote = quote
        routeSuccessSceneLoyaltyInfo = loyaltyInfo
    }
}

class MockQuoteValidityWorker: QuoteValidityWorker {
    var invalidateCalled = false
    func invalidate() {
        invalidateCalled = true
    }
    var setQuoteValidityDeadlineCalled = false
    var setQuoteValidityDeadlineQuote: Quote?

    func setQuoteValidityDeadline(
        _ quote: Quote,
        deadlineCompletion: @escaping () -> Void
    ) {
        setQuoteValidityDeadlineCalled = true
        setQuoteValidityDeadlineQuote = quote
    }
}