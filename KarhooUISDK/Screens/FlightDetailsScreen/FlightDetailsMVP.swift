//
//  FlightDetailsMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

protocol FlightDetailsView: AnyObject {
    func startKeyboardListener()
    func setUpUI()
    func set(formButtonEnabled: Bool)
    func unfocusInputFields()
    func updateFlightNumberField(placeHolder: String)
}

protocol FlightDetailsPresenter: KarhooTextFieldStateDelegate, KarhooTextFieldEvents {
    func load(view: FlightDetailsView)
    func screenWillAppear()
    func didPressCancel()
    func didPressContinue()
    func didSet(additionalInformation: String)
}
