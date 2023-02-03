//
//  DetailsViewCell.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 03/11/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct DetailsCellView: View {
    
    @ObservedObject var viewModel: DetailsCellViewModel
    weak var delegate: DetailsCellViewControllerProtocol?

    var body: some View {
        Group {
            HStack(spacing: UIConstants.Spacing.small) {
                Image(uiImage: UIImage.uisdkImage(viewModel.iconName))
                .frame(
                    width: UIConstants.Dimension.Icon.large,
                    height: UIConstants.Dimension.Icon.large
                )
                .padding(.top, UIConstants.Spacing.xSmall)
                .padding(.bottom, UIConstants.Spacing.xSmall)
                .foregroundColor(Color(KarhooUI.colors.primary))
            VStack(alignment: .leading) {
                Text(viewModel.title)
                    .lineLimit(2)
                    .font(Font(KarhooUI.fonts.headerSemibold()))
                    .foregroundColor(Color(KarhooUI.colors.text))
                Text(viewModel.subtitle)
                    .lineLimit(2)
                    .font(Font(KarhooUI.fonts.footnoteRegular()))
                    .foregroundColor(Color(KarhooUI.colors.textLabel))
            }
                Spacer()
                Image(uiImage:
                    UIImage.uisdkImage("kh_uisdk_right_arrow")
                    .coloured(withTint: KarhooUI.colors.primary)
                )
                .frame(
                    width: UIConstants.Dimension.Icon.standard,
                    height: UIConstants.Dimension.Icon.standard
                )
            }
            .padding(.all, UIConstants.Spacing.standard)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
        }
        .background(
            RoundedRectangle(cornerRadius: UIConstants.CornerRadius.medium)
                .stroke(
                    Color(KarhooUI.colors.border),
                    lineWidth: UIConstants.Dimension.Border.standardWidth
                )
        ).background(
            RoundedRectangle(cornerRadius: UIConstants.CornerRadius.medium)
                .fill(Color(KarhooUI.colors.background2))
        )
        .onTapGesture(perform: {
            delegate?.onTap() // will be removed when Old Checkout will be removed
            viewModel.onTap()
        })
    }
}

struct DetailsViewCellPreviews: PreviewProvider {
    static var previews: some View {
        DetailsCellView(
            viewModel: DetailsCellViewModel(
                title: "Passanger",
                subtitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                iconName: "kh_uisdk_passenger",
                onTap: {print("tapped")}
            ),
            delegate: nil
        )
    }
}
