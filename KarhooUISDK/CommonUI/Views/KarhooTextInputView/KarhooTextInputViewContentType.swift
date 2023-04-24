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
    case flightNumber
    case trainNumber
    
    // TODO: remove this after redoing the passenger details screen
    var placeholderText: String {
        switch self {
        case .firstname:
            return UITexts.User.firstName // "e.g. Fatima"
        case .surname:
            return UITexts.User.lastName // "e.g. Mangani"
        case .email:
            return UITexts.User.email // "e.g. thomamangani@mail.com"
        case .phone:
            return UITexts.User.mobilePhone // "e.g. +447891011123"
        case .comment:
            return UITexts.User.commentOptional
        case .poiDetails:
            return UITexts.Booking.guestCheckoutFlightNumberPlaceholder
        default:
            return ""
        }
    }
    
    var placeholder: String {
        switch self {
        case .firstname:
            return UITexts.Placeholder.firstName
        case .surname:
            return UITexts.Placeholder.lastName
        case .email:
            return UITexts.Placeholder.email
        case .phone:
            return UITexts.Placeholder.mobilePhoneNumber
        case .comment:
            return UITexts.User.commentOptional
        case .poiDetails:
            return UITexts.Placeholder.flightNumber
        case .flightNumber:
            return UITexts.Placeholder.flightNumber
        case .trainNumber:
            return UITexts.Placeholder.trainNumber
        }
    }
    
    // TODO: remove this after redoing the passenger details screen
    
    var titleText: String {
        switch self {
        case .firstname:
            return UITexts.User.firstName
        case .surname:
            return UITexts.User.lastName
        case .email:
            return UITexts.User.email
        case .phone:
            return UITexts.User.mobilePhone
        case .comment:
            return ""
        case .poiDetails:
            return UITexts.Errors.flightNumberValidatorError
        default:
            return ""
        }
    }
    
    var title: String {
        switch self {
        case .firstname:
            return UITexts.User.firstName
        case .surname:
            return UITexts.User.lastName
        case .email:
            return UITexts.User.email
        case .phone:
            return UITexts.User.mobilePhone
        case .comment:
            return UITexts.TripRating.addCommentPlaceholder
        case .poiDetails:
            return UITexts.TripSummary.flightNumber
        case .flightNumber:
            return UITexts.TripSummary.flightNumber
        case .trainNumber:
            return UITexts.TripSummary.trainNumber
        }
    }

    var whitespaceAllowed: Bool {
        switch self {
        case .firstname, .surname, .comment: return true
        default: return false
        }
    }
}
