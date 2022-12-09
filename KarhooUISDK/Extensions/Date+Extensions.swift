//
//  Date+Extensions.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 13.07.2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation

extension Optional where Wrapped == Date {
    
    func toString(format: Date.DateFormat = .iso8601) -> String {
        self?.toString(format: format) ?? ""
    }
}

extension Date {

    enum DateFormat: String {
        case iso8601
    }

    /// Casts date to string using ISO8601 standard
    func toString(
        format: DateFormat = .iso8601,
        locale: Locale = .current,
        timeZone: TimeZone = .current
    ) -> String {
        switch format {
        case .iso8601:
            return getISO8601String()
        }
    }

    private func getISO8601String() -> String {
        let dateString: String

        if #available(iOS 15.0, *) {
            dateString = self.ISO8601Format()
        } else {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dateString = formatter.string(from: self)
        }

        return dateString
    }
}
