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
                .accessibilityLabel(viewModel.accessibilityIconName)
            VStack(alignment: .leading) {
                Text(viewModel.title)
                    .lineLimit(2)
                    .font(Font(KarhooUI.fonts.bodyBold()))
                    .foregroundColor(Color(KarhooUI.colors.text))
                    .accessibilityLabel(viewModel.accessibilityTitle)
                Text(viewModel.subtitle)
                    .lineLimit(2)
                    .font(Font(KarhooUI.fonts.captionRegular()))
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
                .accessibilityLabel(UITexts.Accessibility.editArrow)
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
                accessibilityTitle: "Passenger",
                accessibilityIconName: "Passenger",
                onTap: {print("tapped")}
            )
        )
    }
}
