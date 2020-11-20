//
//  DestinationEtaMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol DestinationEtaView {
    func show(eta: String)
    func hide()
    func start(tripId: String)
    func stop()
}

protocol DestinationEtaPresenter {
    func monitorTrip(tripId: String)
    func stopMonitoringTrip()
}
