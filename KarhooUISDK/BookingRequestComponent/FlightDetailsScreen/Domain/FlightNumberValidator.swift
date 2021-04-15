//
//  FlightNumberValidator.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation

final class FlightNumberValidator: Validator {

    private var listener: ValidatorListener?
    private let minimumInput = 2

    func set(listener: ValidatorListener?) {
       self.listener = listener
    }

    func validate(text: String) {
        text.count >= minimumInput ? listener?.valid() : listener?.invalid(reason: "")
    }
}
