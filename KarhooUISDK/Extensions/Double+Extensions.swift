//
//  Double+Extensions.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 08.02.2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation

extension Optional where Wrapped == Double {
    var amountString: String? {
        guard let self = self else { return nil }
        return String(format: "%.2f", self)
    }
}

extension Double {
    var amountString: String {
        String(format: "%.2f", self)
    }
}
