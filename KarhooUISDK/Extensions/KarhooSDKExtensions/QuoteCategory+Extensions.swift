//
//  QuoteCategory+Extensions.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 02.11.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

extension QuoteCategory {
    var localizedCategoryName: String {
        let value = categoryName.uppercased()
        
        guard let enumCase = QuoteCategoryName(rawValue: value)
        else {
            return categoryName
        }
        
        return enumCase.title
    }
}

public enum QuoteCategoryName: String {
    case electric = "ELECTRIC"
    case mpv = "MPV"
    case saloon = "SALOON"
    case exec = "EXEC"
    case executive = "EXECUTIVE"
    case moto = "MOTO"
    case motorcycle = "MOTORCYCLE"
    case taxi = "TAXI"
    
    var title: String {
        switch self {
        case .electric:
            return UITexts.QuoteCategory.electric
        case .mpv:
            return UITexts.QuoteCategory.mpv
        case .saloon:
            return UITexts.QuoteCategory.saloon
        case .exec:
            return UITexts.QuoteCategory.exec
        case .executive:
            return UITexts.QuoteCategory.executive
        case .moto:
            return UITexts.QuoteCategory.moto
        case .motorcycle:
            return UITexts.QuoteCategory.motorcycle
        case .taxi:
            return UITexts.QuoteCategory.taxi
        }
    }
}
