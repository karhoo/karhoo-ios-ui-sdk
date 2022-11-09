//
//  DetailsViewCell.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 03/11/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct DetailsCellView: View {
    
    @State var title = ""
    @State var subtitle = ""
    @State var iconName: String
    var body: some View {
        Group {
            HStack(spacing: UIConstants.Spacing.small) {
                Image(uiImage: UIImage.uisdkImage(iconName))
                .frame(
                    width: UIConstants.Dimension.Icon.large,
                    height: UIConstants.Dimension.Icon.large
                )
                .foregroundColor(KarhooUI.colors.primary.getColor())
            VStack(alignment: .leading) {
                Text(title)
                    .lineLimit(2)
                    .font(.system(size: 16))
                    .foregroundColor(KarhooUI.colors.text.getColor())
                Text(subtitle)
                    .lineLimit(2)
                    .font(.system(size: 10))
                    .foregroundColor(KarhooUI.colors.textLabel.getColor())
            }
                Spacer().accessibility(identifier: "String")
                Image("kh_uisdk_right_arrow", bundle: .current)
                .frame(
                    width: UIConstants.Dimension.Icon.standard,
                    height: UIConstants.Dimension.Icon.standard
                )
            }
            .padding(.all, 16)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(KarhooUI.colors.border.getColor(), lineWidth: 1)
        ).background(
            RoundedRectangle(cornerRadius: 20)
                .fill(KarhooUI.colors.white.getColor())
        )
        onTapGesture(perform: { return })
    }
}

struct DetailsCellModel{
    var title: String
    var subtitle: String
    var iconName: String
}

struct DetailsViewCell_Previews: PreviewProvider {
    static var previews: some View {
        DetailsCellView(title: "Passanger", subtitle: "add details", iconName: "kh_uisdk_passenger")
    }
}
