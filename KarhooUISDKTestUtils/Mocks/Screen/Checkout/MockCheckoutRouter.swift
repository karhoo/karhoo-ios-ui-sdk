//
//  MockCheckoutRouter.swift
//  KarhooUISDKTestUtils
//
//  Created by Aleksander Wedrychowski on 07/02/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import KarhooSDK
@testable import KarhooUISDK

public class MockCheckoutRouter: CheckoutRouter {
    private(set) public var routeToPriceDetailsCalled: (title: String, quoteType: QuoteType)?
    public func routeToPriceDetails(title: String, quoteType: QuoteType) {
        routeToPriceDetailsCalled = (title, quoteType)
    }

    private(set) public var routeToFlightNumberCalled: (title: String, flightNumber: String)?
    public func routeToFlightNumber(title: String, flightNumber: String) {
        routeToFlightNumberCalled = (title, flightNumber)
    }

    private(set) public var routeToTrainNumberCalled: (title: String, trainNumber: String)?
    public func routeToTrainNumber(title: String, trainNumber: String) {
        routeToTrainNumberCalled = (title, trainNumber)
    }

    private(set) public var routeToCommentCalled: (title: String, comments: String)?
    public func routeToComment(title: String, comments: String) {
        routeToCommentCalled = (title, comments)
    }

    private(set) public var routeToPassengerDetailsCalled: (currentDetails: PassengerDetails?, delegate: PassengerDetailsDelegate?)?
    public func routeToPassengerDetails(_ currentDetails: PassengerDetails?, delegate: PassengerDetailsDelegate?) {
        routeToPassengerDetailsCalled = (currentDetails, delegate)
    }

    private(set) public var routeSuccessSceneCalled: (tripInfo: TripInfo, journeyDetails: JourneyDetails?, quote: Quote, loyaltyInfo: KarhooBasicLoyaltyInfo)?
    public func routeSuccessScene(with tripInfo: TripInfo, journeyDetails: JourneyDetails?, quote: Quote, loyaltyInfo: KarhooBasicLoyaltyInfo) {
        routeSuccessSceneCalled = (tripInfo, journeyDetails, quote, loyaltyInfo)
    }
}
