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
    
    func addFlightDetailsPressed() {
        presenter.didPressAddFlightDetails()
    }
}

extension FormBookingRequestViewController: PassengerDetailsActions {
    func passengerDetailsValid(_ valid: Bool) {
        passengerDetailsValid = valid
        enableBookingButton()
    }
}

extension FormBookingRequestViewController: KarhooInputViewDelegate {
    func didBecomeInactive(identifier: String) {
        enableBookingButton()
    }
    
    func didBecomeActive(identifier: String) {
        enableBookingButton()
    }
    
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
    }
}

extension FormBookingRequestViewController: AddPassengerDetailsViewActions {
    func didUpdatePassengerDetails(details: PassengerDetails?) {
        didBecomeInactive(identifier: commentsInputText.accessibilityIdentifier!)
    }
}

extension FormBookingRequestViewController: RevealMoreButtonActions {
    func learnMorePressed() {
        moreDetailsView.alpha = 0.0
        moreDetailsStackView.addArrangedSubview(moreDetailsView)
        moreDetailsView.anchor(leading: moreDetailsStackView.leadingAnchor,
                                    trailing: moreDetailsStackView.trailingAnchor)
        moreDetailsView.heightAnchor.constraint(greaterThanOrEqualToConstant: 70.0).isActive = true
        UIView.animate(withDuration: 0.25, animations: { [unowned self] in
            self.headerView.hideVehicleCapacityView()
            self.moreDetailsView.alpha = 1.0
        })
    }
    
    func learnLessPressed() {
        UIView.animate(withDuration: 0.45, animations: { [unowned self] in
            self.moreDetailsView.alpha = 0.0
            self.moreDetailsView.removeFromSuperview()
            self.headerView.displayVehicleCapacityView()
        })
    }
}

extension FormBookingRequestViewController: InfoButtonActions {
    func infoButtonPressed() {
        rideInfoStackView.addArrangedSubview(farePriceInfoView)
        farePriceInfoView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50.0).isActive = true
    }
}

