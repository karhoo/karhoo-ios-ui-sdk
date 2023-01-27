//
//  LoyaltyEarnBurnView.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 23/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct LoyaltyEarnBurnView: View {
    
    var viewModel = LoyaltyViewModel(
        loyaltyId: "loyaltyId",
        currency: "PLN",
        tripAmount: 12.5
    )
    
    init(){
           viewModel.balance = 100
           viewModel.canEarn = true
    }

    @State var burnOnInfo = UITexts.Loyalty.info
    
    @State var isBurnModeOn: Bool = true
    
    var body: some View {
        VStack {
            LoyaltyContainerWithBalance(balance: viewModel.balance, content: {
                VStack(alignment: .leading) {
                    if viewModel.canEarn {
                        earnContent
                    }
                    if viewModel.canEarn && viewModel.canBurn {
                        orDivider
                    }
                    if viewModel.canBurn {
                        LoyaltyBurnContent(isToggleOn: $isBurnModeOn)
                    }
                }
            })
            if isBurnModeOn {
                burnInfoView
            }
        }
    }
    
    @ViewBuilder
    private var earnContent: some View {
        let pointsEarnedText =
        String(format: NSLocalizedString(UITexts.Loyalty.pointsEarnedForTrip, comment: ""), "\(viewModel.earnAmount)")
        VStack(alignment: .leading) {
            Text(pointsEarnedText)
                .font(Font(KarhooUI.fonts.bodyRegular()))
                .foregroundColor(Color(KarhooUI.colors.text))
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

struct LoyaltyEarnBurnView_Previews: PreviewProvider {
    static var previews: some View {
        LoyaltyEarnBurnView()
    }
}
