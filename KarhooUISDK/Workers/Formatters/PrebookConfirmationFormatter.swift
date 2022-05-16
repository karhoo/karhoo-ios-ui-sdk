//
//  PrebookConfirmationFormatter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK

final class PrebookConfirmationFormatter {

    static func confirmationMessage(withDetails journeyDetails: JourneyDetails) -> String {
        let pickup = journeyDetails.originLocationDetails?.address.displayAddress ?? ""
        let destination = journeyDetails.destinationLocationDetails?.address.displayAddress ?? ""

        guard let originTimeZone = journeyDetails.originLocationDetails?.timezone() else {
            return String(format: UITexts.Booking.prebookConfirmation, pickup, destination, "")
        }

        let dateFormatter = KarhooDateFormatter(timeZone: originTimeZone)
        let scheduledDate = dateFormatter.display(detailStyleDate: journeyDetails.scheduledDate)

        return String(format: UITexts.Booking.prebookConfirmation, pickup, destination, scheduledDate)
    }
}
