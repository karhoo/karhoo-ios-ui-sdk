//
//  NewLoyaltyView.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 23/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct NewLoyaltyView: View {
    
    @State var title = UITexts.Loyalty.title
    @State var ballanceTitle = UITexts.Loyalty.balanceTitle
    @State var pointsEarnedForTrip = UITexts.Loyalty.pointsEarnedForTrip
    
    @State var burnTitle = UITexts.Loyalty.burnTitle
    @State var burnOffSubtitle = UITexts.Loyalty.burnOffSubtitle
    @State var burnOnSubtitle = UITexts.Loyalty.burnOnSubtitle
    @State var burnOnInfo = UITexts.Loyalty.info

    
    @Binding var isToggleOn: Bool
    
    @State private var ballanceViewPadding = 0.0
    
    
    var body: some View {
        VStack(spacing: UIConstants.Spacing.standard) {
            ZStack{
                VStack(alignment: .leading) {
                    earnView
                    orDivider
                    burnView
                }
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
            burnInfoView
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
    
    @ViewBuilder
    private var earnView: some View {
        VStack(alignment: .leading, spacing: UIConstants.Spacing.xSmall) {
            Text(title)
                .lineLimit(2)
                .font(Font(KarhooUI.fonts.headerSemibold()))
                .foregroundColor(Color(KarhooUI.colors.text))
            Text(pointsEarnedForTrip)
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
    private var burnView: some View {
        HStack {
            VStack(alignment: .leading, spacing: UIConstants.Spacing.xSmall) {
                Text(burnTitle)
                    .lineLimit(2)
                    .font(Font(KarhooUI.fonts.headerSemibold()))
                    .foregroundColor(Color(KarhooUI.colors.text))
                Text(isToggleOn ? burnOnSubtitle : burnOffSubtitle)
                    .font(Font(KarhooUI.fonts.bodyRegular()))
                    .foregroundColor(Color(KarhooUI.colors.text))
            }
                .layoutPriority(Double(UILayoutPriority.defaultHigh.rawValue))
            Toggle("", isOn: $isToggleOn)
                .toggleStyle(SwitchToggleStyle(tint: Color(KarhooUI.colors.secondary)))
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
