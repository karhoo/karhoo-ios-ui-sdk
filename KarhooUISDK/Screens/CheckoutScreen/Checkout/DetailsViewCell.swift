//
//  DetailsViewCell.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 03/11/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct DetailsViewCell: View {
    var body: some View {
        Group {
            HStack(spacing: 10){
//                Image("kh_uisdk_passenger")
            Image(uiImage: UIImage.uisdkImage("kh_uisdk_passenger"))
                    .frame(width: 32, height: 32)
                    .foregroundColor(.red)
                Text("Passanger")

                
            }
            .padding(.all, 16)
//            .background(Color.yellow)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.purple, lineWidth: 1)
            )
        }
    }
}

struct DetailsViewCell_Previews: PreviewProvider {
    static var previews: some View {
        DetailsViewCell()
    }
}
