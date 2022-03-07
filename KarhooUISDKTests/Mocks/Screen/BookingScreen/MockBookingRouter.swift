//
//  MockBookingRouter.swift
//  KarhooUISDKTests
//
//  Created by Aleksander Wedrychowski on 07/03/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import XCTest

@testable import KarhooUISDK

class MockBookingRouter: BookingRouter {

    var routeToQuoteListCalled = false
    func routeToQuoteList(from sender: BaseViewController, details: JourneyDetails) {
        routeToQuoteListCalled = true
    }
}
