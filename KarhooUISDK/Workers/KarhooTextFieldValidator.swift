//
//  KarhooTextFieldValidator.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 23/01/2023.
//

import Foundation

class KarhooTextFieldValidator: TextFieldValidator {
    func getTextFieldValidity(_ newValue: String, contentType: KarhooTextInputViewContentType) -> Bool {
        switch contentType {
        case .email:
            return Utils.isValidEmail(email: newValue)
        case .phone:
            return Utils.isValidPhoneNumber(number: newValue)
        case .firstname, .surname:
            return Utils.isValidName(name: newValue)
        case .trainNumber, .flightNumber:
            return Utils.isAplhanumerical(newValue)
        default:
            return newValue != ""
        }
    }
}

protocol TextFieldValidator {
    func getTextFieldValidity(_ newValue: String, contentType: KarhooTextInputViewContentType) -> Bool
}
