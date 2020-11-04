//
//  JourneySummaryInfoMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

protocol JourneySummaryInfoView: AnyObject {
    func set(viewModel: JourneySummaryInfoViewModel)
}
