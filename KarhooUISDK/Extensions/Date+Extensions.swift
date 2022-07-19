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

    /// Casts date to string using ISO8601 standard
    func toString() -> String {
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
