//
//  NewCheckout+MVPC.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 05/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import KarhooSDK

protocol NewCheckoutCoordinator: KarhooUISDKSceneCoordinator {

}

protocol NewCheckoutViewController: BaseViewController {
}

protocol NewCheckoutRouter: AnyObject {
    func routeToPriceDetails(title: String, quoteType: QuoteType)
    func routeToFlightNumber(title: String, flightNumber: String)
    func routeToTrainNumber(title: String, trainNumber: String)
    
}
