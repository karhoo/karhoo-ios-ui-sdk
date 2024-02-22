//
//  AddressBarMVP.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import CoreLocation
import Foundation
import KarhooSDK

public protocol AddressBarView: BaseView {

    func set(prebookDate: String, prebookTime: String)

    func setDefaultPrebookState()

    func set(pickupDisplayAddress: String?)

    func set(destinationDisplayAddress: String?)

    func destinationSetState(disableClearButton: Bool)

    func destinationNotSetState()

    func pickupNotSetState()

    func pickupSetState()

    func showPickupSpinner()

    func hidePickupSpinner()

    func setDisplayTripState()
}

protocol AddressBarPresenter: JourneyDetailsObserver {

    func load(view: AddressBarView?)

    func addressSelected(type: AddressType)

    func addressCleared(type: AddressType)

    func prebookSelected()

    func prebookSelected(optionalDoneCallback: (() -> Void)?)

    func prebookCleared()

    func addressSwapSelected()
}

extension AddressBarPresenter {
    func prebookSelected() {
        prebookSelected(optionalDoneCallback: nil)
    }
}
