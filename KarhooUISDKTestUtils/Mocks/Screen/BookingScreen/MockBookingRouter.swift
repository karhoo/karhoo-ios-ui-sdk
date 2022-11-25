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
    public init() {}

    public var routeToQuoteListCalled = false
    public func routeToQuoteList(
        details: JourneyDetails,
        onQuoteSelected: @escaping (_ quote: Quote,  _ journeyDetails: JourneyDetails) -> Void
    ) {
        routeToQuoteListCalled = true
    }

<<<<<<< HEAD:KarhooUISDKTests/Mocks/Screen/BookingScreen/MockBookingRouter.swift
    private var bookingRequestCompletion: ((ScreenResult<KarhooCheckoutResult>, Quote, JourneyDetails) -> Void)?
    var routeToCheckoutCalled = false
    var quote: Quote?
    var journeyDetails: JourneyDetails?
    var bookingMetadata: [String: Any]?
    func routeToCheckout(
=======
    private var bookingRequestCompletion: ((ScreenResult<TripInfo>, Quote, JourneyDetails) -> Void)?
    public var routeToCheckoutCalled = false
    public var quote: Quote?
    public var journeyDetails: JourneyDetails?
    public var bookingMetadata: [String: Any]?
    public func routeToCheckout(
>>>>>>> feature/booking-confirmation:KarhooUISDKTestUtils/Mocks/Screen/BookingScreen/MockBookingRouter.swift
        quote: Quote,
        journeyDetails: JourneyDetails,
        bookingMetadata: [String: Any]?,
        bookingRequestCompletion: @escaping (ScreenResult<KarhooCheckoutResult>, Quote, JourneyDetails) -> Void
    ) {
        self.quote = quote
        self.journeyDetails = journeyDetails
        self.bookingRequestCompletion = bookingRequestCompletion
        self.bookingMetadata = bookingMetadata
        routeToCheckoutCalled = true
    }

<<<<<<< HEAD:KarhooUISDKTests/Mocks/Screen/BookingScreen/MockBookingRouter.swift
    func triggerCheckoutScreenResult(_ result: ScreenResult<KarhooCheckoutResult>) {
=======
    public func triggerCheckoutScreenResult(_ result: ScreenResult<TripInfo>) {
>>>>>>> feature/booking-confirmation:KarhooUISDKTestUtils/Mocks/Screen/BookingScreen/MockBookingRouter.swift
        bookingRequestCompletion?(result, quote!, journeyDetails!)
    }
}
