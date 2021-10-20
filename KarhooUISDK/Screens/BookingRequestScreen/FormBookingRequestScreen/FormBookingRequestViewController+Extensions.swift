//
//  FormBookingRequestViewController+Extensions.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 26.08.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

extension FormBookingRequestViewController: TimePriceViewActions {
    func didPressFareExplanation() {
        presenter.didPressFareExplanation()
    }
}

extension FormBookingRequestViewController: BookingButtonActions {
    func addMoreDetails() {
        presenter.addMoreDetails()
    }
    
    func requestPressed() {
        presenter.bookTripPressed()
    }
}

extension FormBookingRequestViewController: PassengerDetailsActions {
    func passengerDetailsValid(_ valid: Bool) {
        passengerDetailsValid = valid
        enableBookingButton()
    }
}

extension FormBookingRequestViewController: KarhooInputViewDelegate {
    func didBecomeInactive(identifier: String) {}
    
    func didBecomeActive(identifier: String) {}
    
    func didChangeCharacterInSet(identifier: String) {}
    
    private func enableBookingButton() {
        if passengerDetailsValid != true {
            bookingButton.setDisabledMode()
        }
    }
}

extension FormBookingRequestViewController: PaymentViewActions {
    func didGetNonce(nonce: String) {
        paymentNonce = nonce
        didBecomeInactive(identifier: commentsInputText.accessibilityIdentifier!)
        presenter.didAddPassengerDetails()
    }
}

extension FormBookingRequestViewController: AddPassengerDetailsViewActions {
    func didUpdatePassengerDetails(details: PassengerDetails?) {
        didBecomeInactive(identifier: commentsInputText.accessibilityIdentifier!)
        presenter.didAddPassengerDetails()
    }
    
    func willUpdatePassengerDetails() {
        presenter.addOrEditPassengerDetails()
    }
}

extension FormBookingRequestViewController: InfoButtonActions {
    func infoButtonPressed() {
        if farePriceInfoView.isDescendant(of: rideInfoStackView) {
            farePriceInfoView.isHidden.toggle()
        } else {
            rideInfoStackView.addArrangedSubview(farePriceInfoView)
            farePriceInfoView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50.0).isActive = true
        }
    }
}

