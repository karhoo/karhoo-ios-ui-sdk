//
//  KarhooAirportBookingPresenter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation

final class KarhooFlightDetailsPresenter: FlightDetailsPresenter {

    private var flightNumber: String?
    private var additionalInformation: String?
    private var flightNumberValid: Bool?
    private weak var view: FlightDetailsView?
    private let completion: ScreenResultCallback<FlightDetails>

    init(completion: @escaping ScreenResultCallback<FlightDetails>) {
        self.completion = completion
    }

    func load(view: FlightDetailsView) {
        self.view = view
        view.startKeyboardListener()
    }

    func didPressCancel() {
        view?.unfocusInputFields()
        finishWithResult(ScreenResult.cancelled(byUser: true))
    }

    func didSet(additionalInformation: String) {
        self.additionalInformation = additionalInformation
    }

    func didPressContinue() {
        view?.unfocusInputFields()

        let flightDetailsAdded = FlightDetails(flightNumber: flightNumber,
                                               comments: additionalInformation)
        finishWithResult(ScreenResult.completed(result: flightDetailsAdded))
    }

    func screenWillAppear() {
        view?.setUpUI()
    }

    func didChange(text: String, isValid: Bool, identifier: Int) {
        if identifier == AirportFields.flightNumber.rawValue {
            flightNumber = text
            flightNumberValid = isValid
        }
        updateFormButton()
    }

    func fieldDidFocus(identifier: Int) {
        guard identifier == AirportFields.flightNumber.rawValue else {
            return
        }
        view?.updateFlightNumberField(placeHolder: UITexts.Errors.flightNumberValidatorError)
    }

    func fieldDidUnFocus(identifier: Int) {
        guard identifier == AirportFields.flightNumber.rawValue else {
            return
        }
        view?.updateFlightNumberField(placeHolder: UITexts.Airport.flightNumber)
    }

    private func updateFormButton() {
        guard let flightNumberValid = self.flightNumberValid else {
            view?.set(formButtonEnabled: false)
            return
        }
        view?.set(formButtonEnabled: flightNumberValid)
    }

    private func finishWithResult(_ result: ScreenResult<FlightDetails>) {
        self.completion(result)
    }
}
