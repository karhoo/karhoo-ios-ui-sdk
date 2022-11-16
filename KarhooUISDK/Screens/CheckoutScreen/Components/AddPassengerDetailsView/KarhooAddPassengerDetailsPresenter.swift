////
////  KarhooAddPassengerDetailsPresenter.swift
////  KarhooUISDK
////
////  Created by Diana Petrea on 26.08.2021.
////  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
////
//
//import Foundation
//import KarhooSDK
//
//class KarhooAddPassengerDetailsPresenter: AddPassengerDetailsPresenter {
//    
//    private let analyticsService: AnalyticsService
//    private let view: AddPassengerView
////    private var details: PassengerDetails?
//    
//    init(analyticsService: AnalyticsService = Karhoo.getAnalyticsService(),
//         view: AddPassengerView = KarhooAddPassengerDetailsView()) {
//        
//        self.analyticsService = analyticsService
//        self.view = view
//        displayAvailablePassengerDetails()
//    }
//    
//    func set(details: PassengerDetails?) {
//        self.details = details
//        displayAvailablePassengerDetails()
//    }
//    
//    private func displayAvailablePassengerDetails() {
//        view.updatePassengerSummary(details: details)
//        
//        if details == nil {
//            view.resetViewState()
//        } else if let details = details, !details.areValid {
//            view.resetViewBorder()
//        } else {
//            view.updateViewState()
//        }
//    }
//}
