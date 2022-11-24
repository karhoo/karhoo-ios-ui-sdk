//
//  LoyaltyInformationView.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 23/11/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

/// View presenting user-friendly information how many poins shall be added/removed to/from Loyalty.
struct KarhooLoyaltyInformationView: View {

    // MARK: - Properties

    let viewModel: ViewModel

    // MARK: - Views

    var body: some View {
        HStack(spacing: UIConstants.Spacing.small) {
            Image("kh_uisdk_info_icon", bundle: .current)
                .resizable()
                .foregroundColor(Color(KarhooUI.colors.primary))
                .frame(width: UIConstants.Dimension.Icon.medium, height: UIConstants.Dimension.Icon.medium)
            Text(viewModel.text)
                .font(Font(KarhooUI.fonts.captionBold()))
                .foregroundColor(Color(KarhooUI.colors.primary))
                .frame(alignment: .leading)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
        }
        .padding(.horizontal, UIConstants.Spacing.medium)
        .padding(.vertical, UIConstants.Spacing.small)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .addBorder(
            Color(KarhooUI.colors.primary),
            cornerRadius: UIConstants.CornerRadius.small
        )
    }

}

// MARK: - Preview
struct KarhooLoyaltyInformationView_Preview: PreviewProvider {
    static var previews: some View {
        KarhooLoyaltyInformationView(viewModel: .init(mode: .earn, pointsToBeModified: 10))
    }
}
