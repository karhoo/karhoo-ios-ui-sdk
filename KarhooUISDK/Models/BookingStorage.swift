//
//  BookingStorage.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 14.04.2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

protocol BookingStorage {
    func reset()
}

/// The purpose of this type is to store all the information needed for a booking for easy access along the booking flow if/when needed
class KarhooBookingStorage: BookingStorage {
    // TODO: add to the list or modify these as needed during implementation
    // MARK: - Properties
    
    let journeyDetailsManager = KarhooJourneyDetailsManager.shared
    let passengerInfo = KarhooPassengerInfo.shared
    let bookingMetadata = KarhooBookingMetadata.shared
    let filters = KarhooQuoteFilters.shared
    
    var quote: Quote?
    var loyaltyInfo: KarhooBasicLoyaltyInfo?
    
    // TODO: double check if these are needed. Delete if not
    var tripInfo: TripInfo?
    var outboundTripId: String?
    
    static let shared = KarhooBookingStorage()
    
   // MARK: - BookingStorage
    func reset() {
        journeyDetailsManager.reset()
        passengerInfo.reset()
        bookingMetadata.reset()
        filters.reset()
        quote = nil
        loyaltyInfo = nil
        tripInfo = nil
        outboundTripId = nil
    }
}
