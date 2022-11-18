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
    var iconName: String { get set }
    var journeyDetails: JourneyDetails { get set }
    var quote: Quote { get set }
    var shouldShowLoyalty: Bool { get set }
    
    func dismiss()
}

extension BookingConfirmationViewModel {
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
}

class KarhooBookingConfirmationViewModel: BookingConfirmationViewModel {
    var iconName: String
    var journeyDetails: JourneyDetails
    var quote: Quote
    var shouldShowLoyalty: Bool
    private var callback: () -> Void
    
    init(
        iconName: String,
        journeyDetails: JourneyDetails,
        quote: Quote,
        shouldShowLoyalty: Bool,
        callback: @escaping () -> Void
    ) {
        self.iconName = iconName
        self.journeyDetails = journeyDetails
        self.quote = quote
        self.shouldShowLoyalty = shouldShowLoyalty
        self.callback = callback
    }
    
    func dismiss() {
        callback()
    }
}
