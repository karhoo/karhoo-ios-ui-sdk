//
//  KarhooFreeCancelationTextWorker.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 13/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

class KarhooFreeCancelationTextWorker {
    static func getFreeCancelationText(trip: TripInfo) -> String? {
        getFreeCancelationText(
            serviceCancellation: trip.serviceAgreements?.serviceCancellation,
            isScheduled: trip.dateBooked != trip.dateScheduled
        )
    }

    static func getFreeCancelationText(quote: Quote, journeyDetails: JourneyDetails) -> String? {
        getFreeCancelationText(
            serviceCancellation: quote.serviceLevelAgreements?.serviceCancellation,
            isScheduled: journeyDetails.isScheduled
        )
    }

    static func getFreeCancelationText(serviceCancellation: ServiceCancellation?, isScheduled: Bool) -> String? {
        switch serviceCancellation?.type {
        case .timeBeforePickup:
            return getTimeBeforePickupText(serviceCancellation: serviceCancellation, isScheduled: isScheduled)
        case .beforeDriverEnRoute:
            return  UITexts.Quotes.freeCancellationBeforeDriverEnRoute
        default:
            return nil
        }
    }

    private static func getTimeBeforePickupText(serviceCancellation: ServiceCancellation?, isScheduled: Bool) -> String? {
        guard
            let freeCancellationMinutes = serviceCancellation?.minutes,
            freeCancellationMinutes > 0
        else {
             return nil
        }
        let timeBeforeCancel = TimeFormatter().minutesAndHours(timeInMinutes: freeCancellationMinutes)
        let messageFormat = isScheduled ? UITexts.Quotes.freeCancellationPrebook : UITexts.Quotes.freeCancellationASAP
        return String(format: messageFormat, timeBeforeCancel)
    }
}
