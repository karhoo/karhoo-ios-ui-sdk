//
//  QuoteType+Description.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//
import KarhooSDK

extension QuoteType {
    public var description: String {

        switch self {
        case .fixed:
            return UITexts.Generic.fixed
        case .estimated:
            return UITexts.Generic.estimated
        case .metered:
            return UITexts.Generic.metered
        }
    }
}
