//
//  TripScreenDetails.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

//TODO: Rename this to Trip and sort old TripDetails to RideDetails (Ride details are currently called TripDetails)
protocol TripScreenDetailsView: UIView {

    func set(actions: TripScreenDetailsActions,
             detailsSuperview: UIView)

    func start(tripId: String)

    func stop()

    func updateViewModel(journeyDetailsViewModel: TripScreenDetailsViewModel)
}

protocol TripScreenDetailsPresenter {

    func startMonitoringTrip(tripId: String)

    func stopMonitoringTrip()
}

protocol TripScreenDetailsActions: AnyObject {

    func cancelTrip()
    
    func journeyDetailViewDidChangeSize()
    
}
