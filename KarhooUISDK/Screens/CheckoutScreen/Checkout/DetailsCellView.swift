//
//  DetailsViewCell.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 03/11/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct DetailsCellView: View {
    
    @ObservedObject var model: DetailsCellViewModel
    weak var delegate: DetailsCellViewControllerProtocol?

    var body: some View {
        Group {
            HStack(spacing: UIConstants.Spacing.small) {
                Image(uiImage: UIImage.uisdkImage(model.iconName))
                .frame(
                    width: UIConstants.Dimension.Icon.large,
                    height: UIConstants.Dimension.Icon.large
                )
                .foregroundColor(KarhooUI.colors.primary.getColor())
            VStack(alignment: .leading) {
                Text(model.title)
                    .lineLimit(2)
                    .font(Font(KarhooUI.fonts.headerSemibold()))
                    .foregroundColor(KarhooUI.colors.text.getColor())
                Text(model.subtitle)
                    .lineLimit(2)
                    .font(Font(KarhooUI.fonts.footnoteRegular()))
                    .foregroundColor(KarhooUI.colors.textLabel.getColor())
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
            RoundedRectangle(cornerRadius: UIConstants.CornerRadius.xxLarge)
                .stroke(
                    KarhooUI.colors.border.getColor(),
                    lineWidth: UIConstants.Dimension.Border.standardWidth
                )
        ).background(
            RoundedRectangle(cornerRadius: UIConstants.CornerRadius.xxLarge)
                .fill(KarhooUI.colors.background2.getColor())
        )
        .onTapGesture(perform: {
            delegate?.onTap()
        })
    }
}

struct DetailsViewCellPreviews: PreviewProvider {
    static var previews: some View {
        DetailsCellView(model: DetailsCellViewModel(title: "Passanger", subtitle: "add details", iconName: "kh_uisdk_passenger"), delegate: nil)
    }
}
