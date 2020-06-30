//
//  TripMetaDataMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol TripMetaDataView {

    func set(viewModel: TripMetaDataViewModel,
             presenter: TripMetaDataPresenter)

    func hideRatingOptions()
}

protocol TripMetaDataPresenter {

    func baseFareExplanationPressed()
    
    func updateFare()
}

protocol TripMetaDataActions: AnyObject {

    func showBaseFareDialog()
}
