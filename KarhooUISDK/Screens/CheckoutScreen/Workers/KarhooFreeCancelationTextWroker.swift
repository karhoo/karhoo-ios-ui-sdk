//
//  KarhooFreeCancelationTextWroker.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 13/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

class KarhooFreeCancelationTextWroker {
    static func getFreeCancelationText(trip: TripInfo) -> String? {
        let isPrebook = trip.dateBooked != trip.dateScheduled
        switch trip.serviceAgreements?.serviceCancellation.type {
        case .timeBeforePickup:
            if let freeCancellationMinutes = trip.serviceAgreements?.serviceCancellation.minutes, freeCancellationMinutes > 0 {
                let timeBeforeCancel = TimeFormatter().minutesAndHours(timeInMinutes: freeCancellationMinutes)
                let messageFormat = isPrebook == true ? UITexts.Quotes.freeCancellationPrebook : UITexts.Quotes.freeCancellationASAP
                return  String(format: messageFormat, timeBeforeCancel)
            } else {
                return nil
            }
        case .beforeDriverEnRoute:
            return  UITexts.Quotes.freeCancellationBeforeDriverEnRoute
        default:
            return nil
        }
    }
}
