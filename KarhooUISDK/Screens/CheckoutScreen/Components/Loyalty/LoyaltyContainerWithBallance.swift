//
//  LoyaltyBallanceView.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 26/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct LoyaltyContainerWithBallance<Content: View>: View {
    
    let ballance: Int
    @ViewBuilder let content: () -> Content
    
    private var ballanceTitle: String {
        String(format: NSLocalizedString(UITexts.Loyalty.balanceTitle, comment: ""), "\(ballance)")
    }
    
    var body: some View {
        ZStack {
            content()
                .padding(.all, UIConstants.Spacing.standard)
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
            ballanceView
        }
    }

    @ViewBuilder
    private var ballanceView: some View {
        HStack {
            Spacer()
            Text(ballanceTitle)
                .font(Font(KarhooUI.fonts.bodyBold()))
                .foregroundColor(Color(KarhooUI.colors.white))
            
                .padding(.vertical, UIConstants.Spacing.small)
                .padding(.horizontal, UIConstants.Spacing.medium)
                .background(
                    RoundedRectangle(cornerRadius: UIConstants.CornerRadius.small)
                        .fill(Color(KarhooUI.colors.primary))
                )
        }
    }
}

struct LoyaltyBallanceView_Previews: PreviewProvider {
    static var previews: some View {
        LoyaltyContainerWithBallance(
            ballance: 1000,
            content: {
                Text("Content")
            }
        )
    }
}
