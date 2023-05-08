//
//  MockBookingRouter.swift
//  KarhooUISDKTests
//
//  Created by Aleksander Wedrychowski on 07/03/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
import XCTest

@testable import KarhooUISDK

class MockBookingRouter: BookingRouter {
    
    var quote: Quote?
    var journeyDetails: JourneyDetails?
    var bookingMetadata: [String: Any]?
    var routeToCheckoutCalled = false
    func routeToCheckout(
        quote: KarhooSDK.Quote,
        journeyDetails: KarhooUISDK.JourneyDetails,
        bookingMetadata: [String : Any]?,
        bookingRequestCompletion: @escaping (KarhooUISDK.ScreenResult<KarhooUISDK.KarhooCheckoutResult>, KarhooSDK.Quote, KarhooUISDK.JourneyDetails) -> Void
    ) {
        self.quote = quote
        self.journeyDetails = journeyDetails
        self.bookingMetadata = bookingMetadata
        routeToCheckoutCalled = true
    }

    var routeToQuoteListCalled = false
    func routeToQuoteList(
        details: JourneyDetails,
        onQuoteSelected: @escaping (_ quote: Quote,  _ journeyDetails: JourneyDetails) -> Void
    ) {
        routeToQuoteListCalled = true
    }
}
