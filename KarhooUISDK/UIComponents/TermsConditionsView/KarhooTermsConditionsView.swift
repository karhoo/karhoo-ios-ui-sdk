//
//  KarhooTermsConditionsView.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 13/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI
import Combine

struct KarhooTermsConditionsView: View {

    private enum Constants {
        static let imageSize = CGSize(width: 20, height: 20)
    }
    @StateObject var viewModel: KarhooTermsConditionsViewModel

    var body: some View {
        HStack(alignment: .top, spacing: UIConstants.Spacing.small) {
            if viewModel.isAcceptanceRequired {
                Button(
                    action: {
                        viewModel.didTapCheckbox()
                },
                    label: {
                        Image(viewModel.imageName, bundle: .current)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(viewModel.imageTint)
                            .frame(
                                width: Constants.imageSize.width,
                                height: Constants.imageSize.height
                            )
                            .padding(2)
                            .overlay(
                                RoundedRectangle(cornerRadius: UIConstants.CornerRadius.small)
                                    .stroke(viewModel.buttonBorderColor, lineWidth: 2)
                            )
                    }
                )
                .accessibilityLabel(UITexts.Accessibility.termsAndConditionsCheckboxLabel)
                .accessibilityHint(UITexts.Accessibility.termsAndConditionsCheckboxHint)
            }

            TextView($viewModel.attributedText)
                .isEditable(false)
                .accessibilityValue(viewModel.accessibilityText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
