//
//  Checkout+MVVMC.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 05/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import KarhooSDK

public protocol CheckoutCoordinator: KarhooUISDKSceneCoordinator {
}

protocol CheckoutViewController: BaseViewController {
}

protocol CheckoutRouter: AnyObject {
    func routeToPriceDetails(title: String, quoteType: QuoteType)
    func routeToFlightNumber(title: String, flightNumber: String)
    func routeToTrainNumber(title: String, trainNumber: String)
    func routeToComment(title: String, comments: String)
    
    func routeToPassengerDetails(
        _ currentDetails: PassengerDetails?,
        delegate: PassengerDetailsDelegate?
    )
    func routeSuccessScene(
        with tripInfo: TripInfo,
        journeyDetails: JourneyDetails?,
        quote: Quote,
        loyaltyInfo: KarhooBasicLoyaltyInfo
    )
}

public struct KarhooCheckoutResult {
    var tripInfo: TripInfo
    var showTripDetails: Bool = false
}
