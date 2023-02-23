//
//  LoyaltyErrorView.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 31/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import SwiftUI

struct LoyaltyErrorView: View {
    var errorMessage: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(UITexts.Loyalty.title)
                .font(Font(KarhooUI.fonts.headerSemibold()))
                .foregroundColor(Color(KarhooUI.colors.text))
            Text(errorMessage)
                .font(Font(KarhooUI.fonts.bodyBold()))
                .foregroundColor(Color(KarhooUI.colors.textError))
        }
        .padding(.all, UIConstants.Spacing.standard)
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .addBorder(Color(KarhooUI.colors.error), cornerRadius: UIConstants.CornerRadius.medium)
        .background(
            RoundedRectangle(cornerRadius: UIConstants.CornerRadius.medium)
                .fill(Color(KarhooUI.colors.background2))
        )
        .alignmentGuide(VerticalAlignment.center) {
            $0[VerticalAlignment.top]
        }
    }
}
