//
//  TripSummaryInfoMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

protocol TripSummaryInfoView: AnyObject {
    func set(viewModel: TripSummaryInfoViewModel)
}
