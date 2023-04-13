//
//  SharedPassengerDetails.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import KarhooSDK

protocol PassengerInfo {
    func getDetails() -> PassengerDetails?
    func set(details: PassengerDetails?)
    func getCountry() -> Country
    func set(country: Country)
    func currentUserAsPassenger() -> PassengerDetails?
}

class KarhooPassengerInfo: PassengerInfo {

    static let shared = KarhooPassengerInfo()

    private var passengerDetails: PassengerDetails?
    
    // Note: Added it here to make it persistent without modifying the network SDK and affecting any backend logic
    private var country: Country?
    
    func getDetails() -> PassengerDetails? {
        return passengerDetails
    }

    func set(details: PassengerDetails?) {
        passengerDetails = details
    }
    
    func getCountry() -> Country {
        if let selectedCountry = country {
            return selectedCountry
        }
        
        guard let code = UserDefaults.standard.string(forKey: Keys.countryCode)
        else {
            set(country: KarhooCountryParser.defaultCountry)
            return KarhooCountryParser.defaultCountry
        }
        
        let country = KarhooCountryParser.getCountry(countryCode: code) ?? KarhooCountryParser.defaultCountry
        set(country: country)
        return country
    }
    
    func set(country: Country) {
        UserDefaults.standard.set(country.code, forKey: Keys.countryCode)
        self.country = country
    }

    func currentUserAsPassenger() -> PassengerDetails? {
        if Karhoo.configuration.authenticationMethod().isGuest() {
            return nil
        }

        guard let currentUser = Karhoo.getUserService().getCurrentUser() else {
            return nil
        }

        return PassengerDetails(user: currentUser)
    }
    
    private struct Keys {
        static let countryCode = "PASSENGER_DETAILS_SELECTED_COUNTRY_CODE"
    }
}
