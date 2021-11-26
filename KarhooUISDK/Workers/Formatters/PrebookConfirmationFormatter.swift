//
//  PrebookConfirmationFormatter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK

final class PrebookConfirmationFormatter {

    static func confirmationMessage(withDetails bookingDetails: BookingDetails) -> String {
        let pickup = bookingDetails.originLocationDetails?.address.displayAddress ?? ""
        let destination = bookingDetails.destinationLocationDetails?.address.displayAddress ?? ""

        guard let originTimeZone = bookingDetails.originLocationDetails?.timezone() else {
            return String(format: UITexts.Booking.prebookConfirmation, pickup, destination, "")
        }

        let dateFormatter = KarhooDateFormatter(timeZone: originTimeZone)
        let scheduledDate = dateFormatter.display(detailStyleDate: bookingDetails.scheduledDate)

        return String(format: UITexts.Booking.prebookConfirmation, pickup, destination, scheduledDate)
    }
}
