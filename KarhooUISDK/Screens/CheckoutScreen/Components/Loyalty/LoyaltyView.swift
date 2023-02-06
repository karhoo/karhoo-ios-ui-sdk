//
//  LoyaltyView.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 23/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI
import Combine
import KarhooSDK

struct LoyaltyView: View {
    
    @ObservedObject var viewModel: LoyaltyViewModel

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
                        if viewModel.canBurn {
                            orDivider
                            burnContent
                        }
                    }
                })
                if viewModel.isBurnModeOn {
                    burnInfoView
                        .transition(.scale)
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
                .fixedSize(horizontal: false, vertical: true)
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
        let burnOnSubtitle = String(
            format: NSLocalizedString(UITexts.Loyalty.burnOnSubtitle, comment: ""),
            "\(viewModel.tripAmount)",
            "\(viewModel.currency)",
            "\(viewModel.burnAmount)"
        )
        HStack {
            VStack(alignment: .leading, spacing: UIConstants.Spacing.xSmall) {
                Text(UITexts.Loyalty.burnTitle)
                    .lineLimit(2)
                    .font(Font(KarhooUI.fonts.headerSemibold()))
                    .foregroundColor(viewModel.burnContentTextColor)
                    .fixedSize(horizontal: false, vertical: true)
                Text(viewModel.isBurnModeOn ? burnOnSubtitle : viewModel.burnOffSubtitle)
                    .font(Font(KarhooUI.fonts.bodyRegular()))
                    .foregroundColor(viewModel.burnContentTextColor)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .layoutPriority(Double(UILayoutPriority.defaultHigh.rawValue))
            Toggle("", isOn: $viewModel.isBurnModeOn.animation())
                .toggleStyle(SwitchToggleStyle(tint: Color(KarhooUI.colors.secondary)))
                .disabled(viewModel.burnSectionDisabled)
        }
    }
    
    @ViewBuilder
    private var burnInfoView: some View {
        HStack {
            Text(UITexts.Loyalty.info)
                .font(Font(KarhooUI.fonts.bodyRegular()))
                .foregroundColor(Color(KarhooUI.colors.white))
                .padding(.all, UIConstants.Spacing.standard)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
        .background(
            RoundedRectangle(cornerRadius: UIConstants.CornerRadius.medium)
                .fill(Color(KarhooUI.colors.primary))
        )
    }
    
    private struct LoyaltyErrorView: View {
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
    
    private struct LoyaltyContainerWithBalance<Content: View>: View {
        
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

}

struct LoyaltyView_Previews: PreviewProvider {
    static var previews: some View {
        LoyaltyView(viewModel: LoyaltyViewModel(worker: KarhooLoyaltyWorker.shared))
    }
}
