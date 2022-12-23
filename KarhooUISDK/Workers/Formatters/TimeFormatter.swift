//
//  TimeFormatter.swift
//  KarhooUISDK
//
//  Created by Cosmin Badulescu on 09.04.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation

struct TimeFormatter {

    private let minutesInHour = 60

    func minutesAndHours(timeInMinutes: Int) -> String {
        let minutes: Int = timeInMinutes % minutesInHour
        let hours: Int = timeInMinutes / minutesInHour
        if hours == 0 {
            return String.localizedStringWithFormat("kh_uisdk_minutes_plurals.other".localized, minutes)
        } else if hours > 0 && minutes == 0 {
            return String.localizedStringWithFormat("kh_uisdk_hours_plural.other".localized, hours)
        } else {
            let hoursText = String.localizedStringWithFormat("kh_uisdk_hours_plural.other".localized, hours)
            let minutesText = String.localizedStringWithFormat("kh_uisdk_minutes_plurals.other".localized, minutes)
            return "\(hoursText) \(UITexts.Quotes.freeCancellationAndKeyword) \(minutesText)"
        }
    }
}
