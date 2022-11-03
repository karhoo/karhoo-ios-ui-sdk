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

class MockBookingRouter: BookingRouter {

    var routeToQuoteListCalled = false
    func routeToQuoteList(
        details: JourneyDetails,
        onQuoteSelected: @escaping (_ quote: Quote,  _ journeyDetails: JourneyDetails) -> Void
    ) {
        routeToQuoteListCalled = true
    }

    private var bookingRequestCompletion: ((ScreenResult<TripInfo>, Quote, JourneyDetails) -> Void)?
    var routeToCheckoutCalled = false
    var quote: Quote?
    var journeyDetails: JourneyDetails?
    var bookingMetadata: [String: Any]?
    func routeToCheckout(
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

    func triggerCheckoutScreenResult(_ result: ScreenResult<TripInfo>) {
        bookingRequestCompletion?(result, quote!, journeyDetails!)
    }
}
