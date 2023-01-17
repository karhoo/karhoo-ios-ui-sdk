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
    var useCalendar: Bool { get }
    var printedTime: String { get }
    var printedDate: String { get }
    var accessibilityDate: String { get }
    var accessibilityPrice: String { get }
    func onAppear()
    func dismiss()
    func onAddToCalendar(viewModel: KarhooAddToCalendarView.ViewModel)
}

extension BookingConfirmationViewModel {
    var printedPickUpAddressLine1: String {
        journeyDetails.printedPickUpAddressLine1
    }
    
    var printedPickUpAddressLine2: String {
        journeyDetails.printedPickUpAddressLine2
    }
    
    var printedDropOffAddressLine1: String {
        journeyDetails.printedDropOffAddressLine1
    }
    
    var printedDropOffAddressLine2: String {
        journeyDetails.printedDropOffAddressLine2
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

    // MARK: - Nested types

    struct LoyaltyInfo: BookingConfirmationLoyaltyInfo {
        var shouldShowLoyalty: Bool
        var loyaltyPoints: Int
        var loyaltyMode: LoyaltyMode
    }

    // MARK: - Properties

    var vehicleImagePlaceholder: String = "kh_uisdk_supplier_logo_placeholder"
    var vehicleImageURL: String = ""
    var journeyDetails: JourneyDetails
    var quote: Quote
    var trip: TripInfo?
    var loyaltyInfo: BookingConfirmationLoyaltyInfo
    let useCalendar: Bool

    private let calendarWorker: AddToCalendarWorker
    private let dateFormatter: DateFormatterType
	private let analytics: Analytics
    private var callback: () -> Void

    // MARK: - Lifecycle

    init(
        journeyDetails: JourneyDetails,
        quote: Quote,
        trip: TripInfo?,
        loyaltyInfo: BookingConfirmationLoyaltyInfo,
        vehicleRuleProvider: VehicleRulesProvider = KarhooVehicleRulesProvider(),
        calendarWorker: AddToCalendarWorker = KarhooAddToCalendarWorker(),
        dateFormatter: DateFormatterType = KarhooDateFormatter(),
		analytics: Analytics = KarhooUISDKConfigurationProvider.configuration.analytics(),
        useCalendar: Bool = KarhooUISDKConfigurationProvider.configuration.useAddToCalendarFeature,
        callback: @escaping () -> Void
    ) {
        self.journeyDetails = journeyDetails
        self.quote = quote
        self.trip = trip
        self.loyaltyInfo = loyaltyInfo
        self.calendarWorker = calendarWorker
        self.dateFormatter = dateFormatter
        self.analytics = analytics
        self.useCalendar = useCalendar
        self.callback = callback
        getImageUrl(for: quote, with: vehicleRuleProvider)
    }

    func onAppear() {
//        reportBookingConfirmationScreenOpened(tripId: trip?.tripId, quoteId: quote.id)
    }
    
    func dismiss() {
        reportRideConfirmationDetailsSelected()
        callback()
    }
    
    func onAddToCalendar(viewModel: KarhooAddToCalendarView.ViewModel) {
        guard let trip = trip else {
            return
        }
        reportRideConfirmationAddToCalendarSelected()
        calendarWorker.addToCalendar(trip) { success in
            viewModel.state = success ? .added : .add
        }
    }

    // MARK: - Get time endpoints

    var printedDate: String {
        guard let originTimeZone = journeyDetails.originLocationDetails?.timezone() else {
            return ""
        }
        dateFormatter.set(timeZone: originTimeZone)

        return dateFormatter.display(shortDate: journeyDetails.scheduledDate)
    }

    var printedTime: String {
        guard let originTimeZone = journeyDetails.originLocationDetails?.timezone() else {
            return ""
        }
        dateFormatter.set(timeZone: originTimeZone)

        return dateFormatter.display(clockTime: journeyDetails.scheduledDate)
    }

    var accessibilityDate: String {
        dateFormatter.display(fullDate: journeyDetails.scheduledDate)
    }

    var accessibilityPrice: String {
        quote.quoteType.description + ", " + CurrencyCodeConverter.toPriceString(quote: quote)
    }

    // MARK: - Helpers

    private func getImageUrl(for quote: Quote, with provider: VehicleRulesProvider) {
        provider.getRule(for: quote) { [weak self] rule in
            self?.vehicleImageURL = rule?.imagePath ?? self?.quote.fleet.logoUrl ?? ""
        }
    }

    // MARK: Analytics

    private func reportBookingConfirmationScreenOpened() {
        analytics.rideConfirmationScreenOpened(date: Date(), tripId: trip?.tripId, quoteId: quote.id)
    }

    private func reportRideConfirmationDetailsSelected(){
        analytics.rideConfirmationDetailsSelected(date: Date(), tripId: trip?.tripId, quoteId: quote.id)
    }

    private func reportRideConfirmationAddToCalendarSelected(){
        analytics.rideConfirmationAddToCalendarSelected(date: Date(), tripId: trip?.tripId, quoteId: quote.id)
    }
}
