//
//  JourneyDetails.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

protocol JourneyDetailsView: UIView {

    func set(actions: JourneyDetailsActions,
             detailsSuperview: UIView)

    func start(tripId: String)

    func stop()

    func updateViewModel(journeyDetailsViewModel: JourneyDetailsViewModel)
}

protocol JourneyDetailsPresenter {

    func startMonitoringTrip(tripId: String)

    func stopMonitoringTrip()
}

protocol JourneyDetailsActions: AnyObject {

    func cancelTrip()
    
    func journeyDetailViewDidChangeSize()
    
}
