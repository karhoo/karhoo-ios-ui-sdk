//
//  KarhooCheckoutViewController+Extensions.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 26.08.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

extension KarhooCheckoutViewController: TimePriceViewDelegate {
    func didPressFareExplanation() {
        presenter.didPressFareExplanation()
    }
}

extension KarhooCheckoutViewController: BookingButtonDelegate {
    func addMoreDetails() {
        presenter.addMoreDetails()
    }
    
    func requestPressed() {
        presenter.completeBookingFlow()
    }
}

extension KarhooCheckoutViewController: PassengerDetailsActions {
    func passengerDetailsValid(_ valid: Bool) {
        passengerDetailsValid = valid
        enableBookingButton()
    }
}

extension KarhooCheckoutViewController: KarhooInputViewDelegate {
    func didBecomeInactive(identifier: String) {}
    
    func didBecomeActive(identifier: String) {}
    
    func didChangeCharacterInSet(identifier: String) {}
    
    private func enableBookingButton() {
        if passengerDetailsValid != true {
            bookingButton.setDisabledMode()
        }
    }
}

//extension KarhooCheckoutViewController: AddPaymentViewDelegate {
//    func didGetNonce(nonce: Nonce) {
//        paymentNonce = nonce
//        didBecomeInactive(identifier: commentsInputText.accessibilityIdentifier!)
//        // TODO: Remove next line
//        presenter.didAddPassengerDetails()
//        presenter.completeBookingFlow()
//    }
//}

extension KarhooCheckoutViewController: AddPassengerDetailsViewDelegate {
    func didUpdatePassengerDetails(details: PassengerDetails?) {
        didBecomeInactive(identifier: commentsInputText.accessibilityIdentifier!)
        presenter.didAddPassengerDetails()
    }
    
    func willUpdatePassengerDetails() {
        presenter.addOrEditPassengerDetails()
    }
}

extension KarhooCheckoutViewController: RideInfoViewDelegate {
    func infoButtonPressed() {
        if farePriceInfoView.isDescendant(of: rideInfoStackView) {
            farePriceInfoView.isHidden.toggle()
        } else {
            rideInfoStackView.addArrangedSubview(farePriceInfoView)
            farePriceInfoView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50.0).isActive = true
        }
    }
}

extension KarhooCheckoutViewController: LoyaltyViewDelegate {
    func didChangeMode(newValue: LoyaltyMode) {
        // Note: toggle book button enabled status if needed
        print("LoyaltyView did change mode")
    }
    
    func didStartLoading() {
        // Note: start activity indicator here if needed
        print("LoyaltyView did start loading")
    }
    
    func didEndLoading() {
        // Note: stop activity indicator here if needed
        print("LoyaltyView did end loading")
    }
}
