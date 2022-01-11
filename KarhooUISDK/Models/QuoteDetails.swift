//
//  QuoteDetails.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 11/01/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

/// Quote decorator to add and share additional properties needed in our UISDK but not provided by backend API.
struct QuoteDetails {
    let quote: Quote
    let quoteExpirationDate: Date
}
