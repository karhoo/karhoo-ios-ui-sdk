//
//  LoyaltyBurnContent.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 26/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct LoyaltyBurnContent: View {
    
    @Binding var isToggleOn: Bool
    private let burnOffSubtitle = UITexts.Loyalty.burnOffSubtitle
    private let burnOnSubtitle = UITexts.Loyalty.burnOnSubtitle
    
    init(isToggleOn: Binding<Bool>){
        self._isToggleOn = isToggleOn
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: UIConstants.Spacing.xSmall) {
                Text(UITexts.Loyalty.burnTitle)
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
}
