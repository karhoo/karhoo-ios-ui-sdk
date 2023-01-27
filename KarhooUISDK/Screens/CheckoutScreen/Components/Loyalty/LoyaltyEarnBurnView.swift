//
//  NewLoyaltyView.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 23/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct NewLoyaltyView: View {
    
    var ballance: Int = 1500

    @State var burnOnInfo = UITexts.Loyalty.info
    
    
    @Binding var isToggleOn: Bool
    
    var body: some View {
        VStack {
            LoyaltyContainerWithBallance(ballance: ballance, content: {
                VStack(alignment: .leading) {
                    LoyaltyEarnContent(pointsEarnedForTrip: 100)
                    orDivider
                    LoyaltyBurnContent()
                }
            })
            if isToggleOn {
                burnInfoView
            }
        }
    }
    
    @ViewBuilder
    private var orDivider: some View {
        HStack(spacing: UIConstants.Spacing.medium) {
            Color(KarhooUI.colors.border)
                .frame(width: .infinity, height: UIConstants.Dimension.Border.standardWidth)
            Text(UITexts.Loyalty.or.uppercased())
                .font(Font(KarhooUI.fonts.bodyBold()))
                .foregroundColor(Color(KarhooUI.colors.textLabel))
                
            Color(KarhooUI.colors.border)
                .frame(width: .infinity, height: UIConstants.Dimension.Border.standardWidth)
        }
    }
    
    @ViewBuilder
    private var burnInfoView: some View {
        HStack {
            Text(burnOnInfo)
                .font(Font(KarhooUI.fonts.bodyRegular()))
                .foregroundColor(Color(KarhooUI.colors.white))
                .padding(.all, UIConstants.Spacing.standard)
            Spacer()
                
        }
            .frame(width: .infinity)
            .background(
                RoundedRectangle(cornerRadius: UIConstants.CornerRadius.small)
                    .fill(Color(KarhooUI.colors.primary))
            )
    }
}

struct NewLoyaltyView_Previews: PreviewProvider {
    @State var isToggleOn = true
    static var previews: some View {
        NewLoyaltyView(isToggleOn: .constant(false))
    }
}
