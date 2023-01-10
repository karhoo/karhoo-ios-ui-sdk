//
//  KarhooAddTrainNumberViewMVP.swift
//
//
//  Created by Bartlomiej Sopala on 09/01/2023.
//

import Foundation
import KarhooSDK

protocol AddTrainNumberViewDelegate: AnyObject {
    func willUpdateTrainNumber()
    func didUpdateTrainNumber(_ trainNumber: String)
}

protocol AddTrainNumberPresenter {
    func set(trainNumber: String)
}

