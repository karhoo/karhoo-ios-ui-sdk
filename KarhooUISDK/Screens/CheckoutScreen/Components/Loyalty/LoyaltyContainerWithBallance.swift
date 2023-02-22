//
//  LoyaltyContainerWithBalance.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 26/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct LoyaltyContainerWithBalance<Content: View>: View {
    
    let balance: Int
    @ViewBuilder let content: () -> Content
    
    private var balanceTitle: String {
        String(format: NSLocalizedString(UITexts.Loyalty.balanceTitle, comment: ""), "\(balance)")
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: UIConstants.Spacing.xSmall) {
                Text(UITexts.Loyalty.title)
                    .font(Font(KarhooUI.fonts.headerSemibold()))
                    .foregroundColor(Color(KarhooUI.colors.text))
                content()
            }
            .padding(.all, UIConstants.Spacing.standard)
            // additional top padding to move title lower than balance view
            .padding(.top, UIConstants.Spacing.small)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .addBorder(Color(KarhooUI.colors.border), cornerRadius: UIConstants.CornerRadius.medium)
            .background(
                RoundedRectangle(cornerRadius: UIConstants.CornerRadius.medium)
                    .fill(Color(KarhooUI.colors.background2))
            )
            .alignmentGuide(VerticalAlignment.center) {
                $0[VerticalAlignment.top]
            }
            balanceView
        }
    }

    @ViewBuilder
    private var balanceView: some View {
        HStack {
            Spacer()
            Text(balanceTitle)
                .font(Font(KarhooUI.fonts.bodyBold()))
                .foregroundColor(Color(KarhooUI.colors.white))
            
                .padding(.vertical, UIConstants.Spacing.small)
                .padding(.horizontal, UIConstants.Spacing.medium)
                .background(
                    RoundedRectangle(cornerRadius: UIConstants.CornerRadius.medium)
                        .fill(Color(KarhooUI.colors.primary))
                )
        }
    }
}

struct LoyaltyBalanceView_Previews: PreviewProvider {
    static var previews: some View {
        LoyaltyContainerWithBalance(
            balance: 1000,
            content: {
                Text("Content")
            }
        )
    }
}
