//
//  Date+Extensions.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 13.07.2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation

extension Optional where Wrapped == Date {
    
    func toString() -> String? {
        self?.toString()
    }
}

extension Date {

    enum KarhooDateFormat: String {
        case iso8601
        case longReadable
    }
    /// Casts date to string using ISO8601 standard
    func toString(format: KarhooDateFormat = .iso8601) -> String {
        switch format {
        case .iso8601:
            return getISO8601String()
        case .longReadable:
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .full
            return formatter.string(from: self)
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
