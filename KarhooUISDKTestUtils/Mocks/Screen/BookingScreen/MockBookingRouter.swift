//
//  MockBookingRouter.swift
//  KarhooUISDKTests
//
//  Created by Aleksander Wedrychowski on 07/03/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

@testable import KarhooUISDK

public class MockBookingRouter: BookingRouter {

    public var routeToQuoteListCalled = false
    public func routeToQuoteList(
        details: JourneyDetails,
        onQuoteSelected: @escaping (_ quote: Quote,  _ journeyDetails: JourneyDetails) -> Void
    ) {
        routeToQuoteListCalled = true
    }

    private var bookingRequestCompletion: ((ScreenResult<TripInfo>, Quote, JourneyDetails) -> Void)?
    public var routeToCheckoutCalled = false
    public var quote: Quote?
    public var journeyDetails: JourneyDetails?
    public var bookingMetadata: [String: Any]?
    public func routeToCheckout(
        quote: Quote,
        journeyDetails: JourneyDetails,
        bookingMetadata: [String: Any]?,
        bookingRequestCompletion: @escaping (ScreenResult<TripInfo>, Quote, JourneyDetails) -> Void
    ) {
        self.quote = quote
        self.journeyDetails = journeyDetails
        self.bookingRequestCompletion = bookingRequestCompletion
        self.bookingMetadata = bookingMetadata
        routeToCheckoutCalled = true
    }

    public func triggerCheckoutScreenResult(_ result: ScreenResult<TripInfo>) {
        bookingRequestCompletion?(result, quote!, journeyDetails!)
    }
}
