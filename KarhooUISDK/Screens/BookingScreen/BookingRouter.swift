//
//  BookingRouter.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 04.03.2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation

class KarhooBookingRouter: BookingRouter {
    
    func routeToQuoteList(from sender: BaseViewController, details: JourneyDetails) {
        let quoteList = QuoteList.build(journeyDetails: details)
        sender.push(quoteList)
    }
}
