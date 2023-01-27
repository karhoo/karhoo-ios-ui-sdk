//
//  LoyaltyEarnContent.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 26/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct LoyaltyEarnContent: View {
    
    let pointsEarnedForTrip: Int
    var title = UITexts.Loyalty.title
    private var pointsEarnedText: String {
        String(format: NSLocalizedString(UITexts.Loyalty.pointsEarnedForTrip, comment: ""), "\(pointsEarnedForTrip)")
    }
        
    var body: some View {
        VStack(alignment: .leading, spacing: UIConstants.Spacing.xSmall) {
            Text(title)
                .lineLimit(2)
                .font(Font(KarhooUI.fonts.headerSemibold()))
                .foregroundColor(Color(KarhooUI.colors.text))
            Text(pointsEarnedText)
                .font(Font(KarhooUI.fonts.bodyRegular()))
                .foregroundColor(Color(KarhooUI.colors.text))
        }
    }
}
