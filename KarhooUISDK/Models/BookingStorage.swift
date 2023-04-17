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
    
    let journeyDetailsManager: JourneyDetailsManager
    let passengerInfo: PassengerInfo
    let filters: QuoteFilters
    
    var quote: Quote?
    var loyaltyInfo: KarhooBasicLoyaltyInfo?
    var bookingMetadata: [String: Any]?
    
    // TODO: double check if these are needed. Delete if not
    var tripInfo: TripInfo?
    var outboundTripId: String?
    
    static let shared = KarhooBookingStorage()
    
    // MARK: - Init
    
    init(
        journeyDetailsManager: JourneyDetailsManager = KarhooJourneyDetailsManager.shared,
        passengerInfo: PassengerInfo = KarhooPassengerInfo.shared,
        filters: QuoteFilters = KarhooQuoteFilters.shared,
        quote: Quote? = nil,
        loyaltyInfo: KarhooBasicLoyaltyInfo? = nil,
        bookingMetadata: [String: Any]? = nil,
        tripInfo: TripInfo? = nil,
        outboundTripId: String? = nil
    ) {
        self.journeyDetailsManager = journeyDetailsManager
        self.passengerInfo = passengerInfo
        self.filters = filters
        self.quote = quote
        self.loyaltyInfo = loyaltyInfo
        self.bookingMetadata = bookingMetadata
        self.tripInfo = tripInfo
        self.outboundTripId = outboundTripId
    }
    
   // MARK: - BookingStorage
    func reset() {
        journeyDetailsManager.reset()
        passengerInfo.reset()
        filters.reset()
        quote = nil
        loyaltyInfo = nil
        bookingMetadata = nil
        tripInfo = nil
        outboundTripId = nil
    }
}
