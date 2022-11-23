//
//  LoyaltyInformationView.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 23/11/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct KarhooLoyaltyInformationView: View {

    private enum Constants {
        static let iconSide: CGFloat = 16
    }

    // MARK: - Properties

    let viewModel: ViewModel

    // MARK: - Lifecycle

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Views

    var body: some View {
        HStack(spacing: UIConstants.Spacing.small) {
            Image("kh_uisdk_info_icon", bundle: .current)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(Color(KarhooUI.colors.primary))
                .frame(width: Constants.iconSide, height: Constants.iconSide)
            Text(viewModel.text)
                .font(Font(KarhooUI.fonts.bodyBold()))
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
        .colorScheme(.light)
    }

    
}

// MARK: - Preview
struct KarhooLoyaltyInformationView_Preview: PreviewProvider {
    static var previews: some View {
        KarhooLoyaltyInformationView(viewModel: .init( mode: .earn, points: 10))
    }
}
