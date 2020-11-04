//
//  KarhooJourneyOptionsPresenter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class KarhooJourneyOptionsPresenter: JourneyOptionsPresenter {

    private let phoneNumberCaller: PhoneNumberCallerProtocol

    init(phoneNumberCaller: PhoneNumberCallerProtocol = PhoneNumberCaller()) {
        self.phoneNumberCaller = phoneNumberCaller
    }

    func call(phoneNumber: String) {
        phoneNumberCaller.call(number: phoneNumber)
    }
}
