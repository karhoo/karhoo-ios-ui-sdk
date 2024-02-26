//
//  TripDetailsMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

protocol TripScreenDetailsView: UIView {

    func set(actions: TripScreenDetailsActions,
             detailsSuperview: UIView)

    func start(tripId: String)

    func stop()

    func updateViewModel(tripDetailsViewModel: TripScreenDetailsViewModel)
}

protocol TripScreenDetailsPresenter {

    func startMonitoringTrip(tripId: String)

    func stopMonitoringTrip()
}

protocol TripScreenDetailsActions: AnyObject {

    func cancelTrip()
    
    func tripDetailViewDidChangeSize()

    func contactDriver(_ phoneNumber: String)

    func contactFleet(_ phoneNumber: String)
    
}
