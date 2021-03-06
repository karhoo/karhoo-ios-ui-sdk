//
//  RideDetailsStackButtonMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol RideDetailsStackButtonActions: AnyObject {

    func cancelRide()

    func rebookRide()

    func trackRide()

    func hideRideOptions()

    func reportIssueError()
}
