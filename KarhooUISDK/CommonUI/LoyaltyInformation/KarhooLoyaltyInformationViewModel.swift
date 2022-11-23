//
//  KarhooLoyaltyInformationViewModel.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 23/11/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

extension KarhooLoyaltyInformationView {
    struct ViewModel {

        let mode: LoyaltyMode
        /// Points added or removed from loyalty.
        let pointsToBeModified: Int

        var text: String {
            switch mode {
            case .earn:
                return String(
                    format: UITexts.Loyalty.loyaltyPointsAddInfo,
                    pointsToBeModified.description
                )
            case .burn:
                return String(
                    format: UITexts.Loyalty.loyaltyPointsRemovedInfo,
                    pointsToBeModified.description
                )
            default:
                assertionFailure("View is designed to show earn/burn only")
                return ""
            }
        }
    }
}
