//
//  LoyaltyEarnBurnView.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 23/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI
import Combine
import KarhooSDK

struct LoyaltyEarnBurnView: View {
    
    @ObservedObject var viewModel: NewLoyaltyViewModel

    @State var burnOnInfo = UITexts.Loyalty.info
        
    var body: some View {
        if let error = viewModel.error {
            LoyaltyErrorView(errorMessage: error.text)
                .padding(.top, UIConstants.Spacing.standard)
        } else if viewModel.canEarn || viewModel.canBurn {
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
                            burnContent
                        }
                    }
                })
                if viewModel.isBurnModeOn {
                    burnInfoView
                }
            }
                .padding(.top, UIConstants.Spacing.standard)
        }
    }
    
    @ViewBuilder
    private var earnContent: some View {
        let pointsEarnedText = String(
            format: NSLocalizedString(UITexts.Loyalty.pointsEarnedForTrip, comment: ""),
            "\(viewModel.earnAmount)"
        )
        
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
    private var burnContent: some View {
        let burnOffSubtitle = UITexts.Loyalty.burnOffSubtitle
        let burnOnSubtitle = String(
            format: NSLocalizedString(UITexts.Loyalty.burnOnSubtitle, comment: ""),
            "\(viewModel.currency)",
            "\(viewModel.burnAmount)"
        )
        var textColor = Color(viewModel.burnSectionDisabled ? KarhooUI.colors.inactive : KarhooUI.colors.text)

        HStack {
            VStack(alignment: .leading, spacing: UIConstants.Spacing.xSmall) {
                Text(UITexts.Loyalty.burnTitle)
                    .lineLimit(2)
                    .font(Font(KarhooUI.fonts.headerSemibold()))
                    .foregroundColor(textColor)
                Text(viewModel.isBurnModeOn ? burnOnSubtitle : burnOffSubtitle)
                    .font(Font(KarhooUI.fonts.bodyRegular()))
                    .foregroundColor(textColor)
            }
            .layoutPriority(Double(UILayoutPriority.defaultHigh.rawValue))
            Toggle("", isOn: $viewModel.isBurnModeOn)
                .toggleStyle(SwitchToggleStyle(tint: Color(KarhooUI.colors.secondary)))
                .disabled(viewModel.burnSectionDisabled)
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
        LoyaltyEarnBurnView(viewModel: NewLoyaltyViewModel(worker: KarhooLoyaltyWorker.shared))
    }
}
