//
//  KarhooTextInputViewContentType.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation

enum KarhooTextInputViewContentType {
    case firstname
    case surname
    case email
    case phone
    case comment
    case poiDetails
    
    var placeholderText: String {
        switch self {
        case .firstname:
            return UITexts.Generic.name // "e.g. Fatima"
        case .surname:
            return UITexts.Generic.surname // "e.g. Mangani"
        case .email:
            return UITexts.Generic.email // "e.g. thomamangani@mail.com"
        case .phone:
            return UITexts.Generic.phone // "e.g. +447891011123"
        case .comment:
            return UITexts.Generic.commentOptional
        case .poiDetails:
            return UITexts.Booking.guestCheckoutFlightNumberPlaceholder
        }
    }
    
    var titleText: String {
        switch self {
        case .firstname:
            return UITexts.Generic.name
        case .surname:
            return UITexts.Generic.surname
        case .email:
            return UITexts.Generic.email
        case .phone:
            return UITexts.Generic.phone
        case .comment:
            return UITexts.Generic.comment
        case .poiDetails:
            return UITexts.Errors.flightNumberValidatorError
        }
    }

    var whitespaceAllowed: Bool {
        switch self {
        case .firstname, .surname, .comment: return true
        default: return false
        }
    }
}
