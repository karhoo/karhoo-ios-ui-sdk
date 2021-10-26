//
//  KarhooAddPassengerDetailsMVP.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 26.08.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

protocol AddPassengerDetailsViewDelegate {
    func willUpdatePassengerDetails()
    func didUpdatePassengerDetails(details: PassengerDetails?)
}

protocol AddPassengerDetailsPresenter {
    func set(details: PassengerDetails?)
}

protocol AddPassengerView: BaseView {
    var baseViewController: BaseViewController? { get set }
    var actions: AddPassengerDetailsViewDelegate? { get set }
    func set(details: PassengerDetails?)
    func validDetails() -> Bool
    func showError()
    func updateViewState()
    func resetViewState()
    func resetViewBorder()
    func updatePassengerSummary(details: PassengerDetails?)
}
