//
//  LoyaltyBurnContent.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 26/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct LoyaltyBurnContent: View {
    
    @State var burnTitle = UITexts.Loyalty.burnTitle
    @State var burnOffSubtitle = UITexts.Loyalty.burnOffSubtitle
    @State var burnOnSubtitle = UITexts.Loyalty.burnOnSubtitle
    
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

struct LoyaltyBurnContent_Previews: PreviewProvider {
    static var previews: some View {
        LoyaltyBurnContent()
    }
}
