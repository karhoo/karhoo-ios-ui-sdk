//
//  DetailsViewCell.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 03/11/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct DetailsViewCell: View {
    
    var title: String = "Passenger name"
    var body: some View {
        Group {
            HStack(spacing: UIConstants.Spacing.small) {
            Image(uiImage: UIImage.uisdkImage("kh_uisdk_passenger"))
                    .frame(
                        width: UIConstants.Dimension.Icon.large,
                        height: UIConstants.Dimension.Icon.large
                    )
                    .foregroundColor(.red)
                VStack(alignment: .leading) {
                    Text(title).lineLimit(2).font(.system(size: 16))
                    Text("add details").lineLimit(2).font(.system(size: 10))
                }
                .background(Color.red)
                Spacer()
                Image("kh_uisdk_right_arrow", bundle: .current)
                    .frame(
                        width: UIConstants.Dimension.Icon.standard,
                        height: UIConstants.Dimension.Icon.standard
                    )
            }
            .padding(.all, 16)
//            .background(Color.yellow)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.red, lineWidth: 1)
            )
        }
    }
}

struct DetailsViewCell_Previews: PreviewProvider {
    static var previews: some View {
        DetailsViewCell()
    }
}
