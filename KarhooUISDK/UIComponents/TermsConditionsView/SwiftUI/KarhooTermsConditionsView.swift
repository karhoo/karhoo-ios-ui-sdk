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
                        viewModel.confirmed.toggle()
                },
                    label: {
                        Image(viewModel.imageName, bundle: .current)
                            .resizable()
                            .foregroundColor(Color(KarhooUI.colors.border))
                            .frame(width: Constants.imageSize.width, height: Constants.imageSize.height)
                    }
                )
            }

            TextView($viewModel.attributedText)
                .isEditable(false)
                .accessibilityValue(viewModel.accessibilityText)
        }
    }
}
