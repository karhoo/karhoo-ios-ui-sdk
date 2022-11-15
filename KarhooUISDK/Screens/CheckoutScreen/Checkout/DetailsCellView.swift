//
//  DetailsViewCell.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 03/11/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct DetailsCellView: View {
    
    @ObservedObject var model: DetailsCellModel
    var delegate: DetailsCellViewControllerProtocol? = nil

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
                    .font(.system(size: 16))
                    .foregroundColor(KarhooUI.colors.text.getColor())
                Text(model.subtitle)
                    .lineLimit(2)
                    .font(.system(size: 10))
                    .foregroundColor(KarhooUI.colors.textLabel.getColor())
            }
                Spacer().accessibility(identifier: "String")
                Image("kh_uisdk_right_arrow", bundle: .current)
                .frame(
                    width: UIConstants.Dimension.Icon.standard,
                    height: UIConstants.Dimension.Icon.standard
                ).foregroundColor(KarhooUI.colors.primary.getColor())
            }
            .padding(.all, 16)
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
            delegate?.onClickAction()
        })
    }
}

struct DetailsViewCell_Previews: PreviewProvider {
    static var previews: some View {
        DetailsCellView(model: DetailsCellModel(title: "Passanger", subtitle: "add details", iconName: "kh_uisdk_passenger"), delegate: nil)
    }
}
