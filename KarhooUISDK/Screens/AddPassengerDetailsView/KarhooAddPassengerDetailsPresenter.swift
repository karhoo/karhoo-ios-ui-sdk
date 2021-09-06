//
//  KarhooAddPassengerDetailsPresenter.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 26.08.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

class KarhooAddPassengerDetailsPresenter: AddPassengerDetailsPresenter {
    
    private let analyticsService: AnalyticsService
    private let view: AddPassengerView
    private var details: PassengerDetails?
    
    init(analyticsService: AnalyticsService = Karhoo.getAnalyticsService(),
         view: AddPassengerView = KarhooAddPassengerDetailsView()) {
        
        self.analyticsService = analyticsService
        self.view = view
        displayAvailablePassengerDetails()
    }
    
    func updatePassengerDetailsPressed() {
       // TODO: Consider adding an analytics event for this action in the NSDK. See KarhooPaymentPresenter for a usage example
        
        let presenter = PassengerDetailsPresenter()
        let detailsViewController = PassengerDetailsViewController(presenter: presenter)
        view.baseViewController?.showAsOverlay(item: detailsViewController, animated: true)
    }
    
    func set(details: PassengerDetails?) {
        self.details = details
        displayAvailablePassengerDetails()
    }
    
    private func displayAvailablePassengerDetails() {
        view.updatePassengerSummary(details: details)
        
        guard details != nil
        else {
            view.resetViewState()
            return
        }
        
        view.updateViewState()
    }
}
