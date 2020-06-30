//
//  BookingAllocationSpinnerMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol BookingAllocationSpinnerView: AnyObject {

    func startRotation()

    func stopRotation()
}

protocol BookingAllocationSpinnerPresenter {

    func startMonitoringAppState()

    func stopMonitoringAppState()
}
