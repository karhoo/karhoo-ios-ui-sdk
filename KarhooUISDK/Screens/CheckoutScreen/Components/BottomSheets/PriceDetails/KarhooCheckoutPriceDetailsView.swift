//
//  KarhooCheckoutPriceDetailsView.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 12.01.2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct KarhooCheckoutPriceDetailsView: View {
    @StateObject var viewModel: KarhooCheckoutPriceDetailsViewModel
    
    var body: some View {
        Text(viewModel.getDescriptionText())
            .font(Font(KarhooUI.fonts.bodyRegular()))
            .foregroundColor(Color(KarhooUI.colors.textLabel))
            .frame(alignment: .leading)
    }
}

struct CheckoutPriceDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        KarhooCheckoutPriceDetailsView(
            viewModel: KarhooCheckoutPriceDetailsViewModel(
                quoteType: .estimated
            )
        )
    }
}
