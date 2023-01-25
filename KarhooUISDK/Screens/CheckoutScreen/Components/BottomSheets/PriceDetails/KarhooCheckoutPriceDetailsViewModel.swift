//
//  CheckoutPriceDetailsViewModel.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 12.01.2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

final class KarhooCheckoutPriceDetailsViewModel: ObservableObject {
    private var quoteType: QuoteType
    
    init(quoteType: QuoteType) {
        self.quoteType = quoteType
    }
    
    func getDescriptionText() -> String {
        switch quoteType {
        case .estimated:
            return UITexts.Booking.estimatedInfoBox
        case .fixed:
            return UITexts.Booking.fixedInfoBox
        case .metered:
            return UITexts.Booking.meteredInfoBox
        @unknown default:
            fatalError()
        }
    }
}
