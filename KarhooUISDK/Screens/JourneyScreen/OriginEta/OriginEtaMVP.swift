//
//  OriginEtaMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol OriginEtaView {
    func show(eta: String)
    func hide()
    func start(tripId: String)
    func stop()
}

protocol OriginEtaPresenter {
    func monitorTrip(tripId: String)
    func stopMonitoringTrip()
}
