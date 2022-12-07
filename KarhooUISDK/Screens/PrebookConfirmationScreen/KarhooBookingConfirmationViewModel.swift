//
//  BookingConfirmationViewModel.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 18.11.2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
import SwiftUI

protocol BookingConfirmationViewModel {
    var vehicleImageURL: String { get set }
    var vehicleImagePlaceholder: String { get set }
    var journeyDetails: JourneyDetails { get set }
    var quote: Quote { get set }
    var trip: TripInfo? { get set }
    var loyaltyInfo: BookingConfirmationLoyaltyInfo { get set }
    
    func dismiss()
    func onAddToCalendar(viewModel: KarhooAddToCalendarView.ViewModel)
}

extension BookingConfirmationViewModel {
    var printedPickUpAddressLine1: String {
        journeyDetails.originLocationDetails?.address.displayAddress ?? ""
    }
    
    var printedPickUpAddressLine2: String {
        var result = ""
        
        if let city = journeyDetails.originLocationDetails?.address.city {
            result += "\(city) "
        }
        
        if let postalCode = journeyDetails.originLocationDetails?.address.postalCode {
            result += postalCode
        }
        
        if let country = journeyDetails.originLocationDetails?.address.countryCode {
            result += ", \(country)"
        }
        
        return result
    }
    
    var printedDropOffAddressLine1: String {
        journeyDetails.destinationLocationDetails?.address.displayAddress ?? ""
    }
    
    var printedDropOffAddressLine2: String {
        var result = ""
        
        if let city = journeyDetails.destinationLocationDetails?.address.city {
            result += "\(city) "
        }
        
        if let postalCode = journeyDetails.destinationLocationDetails?.address.postalCode {
            result += postalCode
        }
        
        if let country = journeyDetails.destinationLocationDetails?.address.countryCode {
            result += ", \(country)"
        }
        
        return result
    }
    
    var printedDate: String {
        guard let originTimeZone = journeyDetails.originLocationDetails?.timezone() else {
            return ""
        }
        
        let dateFormatter = KarhooDateFormatter()
        dateFormatter.set(timeZone: originTimeZone)
        return dateFormatter.display(shortDate: journeyDetails.scheduledDate)
    }
    
    var printedTime: String {
        guard let originTimeZone = journeyDetails.originLocationDetails?.timezone() else {
            return ""
        }
        
        let dateFormatter = KarhooDateFormatter()
        dateFormatter.set(timeZone: originTimeZone)
        return dateFormatter.display(clockTime: journeyDetails.scheduledDate)
    }
    
    var printedPrice: String {
        CurrencyCodeConverter.toPriceString(quote: quote)
    }
    
    var printedPriceType: String {
        quote.quoteType.description
    }
    
    var vehicleImagePlaceholder: String {
        "kh_uisdk_supplier_logo_placeholder"
    }
}

protocol BookingConfirmationLoyaltyInfo {
    var shouldShowLoyalty: Bool { get set }
    var loyaltyPoints: Int { get set }
    var loyaltyMode: LoyaltyMode { get set }
}

class KarhooBookingConfirmationViewModel: BookingConfirmationViewModel {
    var vehicleImagePlaceholder: String = "kh_uisdk_supplier_logo_placeholder"
    
    var vehicleImageURL: String = ""
    var journeyDetails: JourneyDetails
    var quote: Quote
    var trip: TripInfo?
    var loyaltyInfo: BookingConfirmationLoyaltyInfo
    var calendarWorker: AddToCalendarWorker = KarhooAddToCalendarWorker()
    
    private var callback: () -> Void
    
    init(
        journeyDetails: JourneyDetails,
        quote: Quote,
        trip: TripInfo?,
        loyaltyInfo: BookingConfirmationLoyaltyInfo,
        vehicleRuleProvider: VehicleRulesProvider = KarhooVehicleRulesProvider(),
        calendarWorker: AddToCalendarWorker = KarhooAddToCalendarWorker(),
        callback: @escaping () -> Void
    ) {
        self.journeyDetails = journeyDetails
        self.quote = quote
        self.trip = trip
        self.loyaltyInfo = loyaltyInfo
        self.calendarWorker = calendarWorker
        self.callback = callback
        getImageUrl(for: quote, with: vehicleRuleProvider)
    }
    
    func dismiss() {
        callback()
    }
    
    func onAddToCalendar(viewModel: KarhooAddToCalendarView.ViewModel) {
        guard let trip = trip else {
            return
        }
        
        calendarWorker.addToCalendar(trip) { success in
            viewModel.state = success ? .added : .add
        }
    }
    
    private func getImageUrl(for quote: Quote, with provider: VehicleRulesProvider) {
        provider.getRule(for: quote) { [weak self] rule in
            self?.vehicleImageURL = rule?.imagePath ?? self?.quote.fleet.logoUrl ?? ""
        }
    }
}

struct KarhooBookingConfirmationLoyaltyInfo: BookingConfirmationLoyaltyInfo {
    var shouldShowLoyalty: Bool
    var loyaltyPoints: Int
    var loyaltyMode: LoyaltyMode
}
