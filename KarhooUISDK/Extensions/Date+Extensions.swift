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
    
    func toString() -> String {
        let dateString: String
        
        if #available(iOS 15.0, *) {
            dateString = self.ISO8601Format()
        } else {
            let formatter = DateFormatter()
            dateString = formatter.string(from: self)
        }
        
        return dateString
    }
}
