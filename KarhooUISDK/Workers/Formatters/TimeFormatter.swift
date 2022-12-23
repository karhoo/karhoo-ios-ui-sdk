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
            if minutes == 1 {
                return String.localizedStringWithFormat("kh_uisdk_minutes_plurals.one".localized, minutes)
            } else {
                return String.localizedStringWithFormat("kh_uisdk_minutes_plurals.other".localized, minutes)
            }
            return String.localizedStringWithFormat("kh_uisdk_minutes_plurals.zero".localized, minutes)
        } else if hours > 0 && minutes == 0 {
            if hours == 1 {
                return String.localizedStringWithFormat("kh_uisdk_hours_plural.one".localized, hours)
            } else {
                return String.localizedStringWithFormat("kh_uisdk_hours_plural.other".localized, hours)
            }
        } else {
            var hoursText: String {
                if hours == 1 {
                    return String.localizedStringWithFormat("kh_uisdk_hours_plural.one".localized, hours)
                } else {
                    return String.localizedStringWithFormat("kh_uisdk_hours_plural.other".localized, hours)
                }
            }
            var minutesText: String {
                if minutes == 1 {
                    return String.localizedStringWithFormat("kh_uisdk_minutes_plurals.one".localized, minutes)
                } else {
                    return String.localizedStringWithFormat("kh_uisdk_minutes_plurals.other".localized, minutes)
                }
            }
            return "\(hoursText) \(UITexts.Quotes.freeCancellationAndKeyword) \(minutesText)"
        }
    }
}
