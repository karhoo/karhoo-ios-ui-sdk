//
//  NewVehicleCapacity.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 13/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

struct NewVehicleCapacity: View {
    var passangerCapacity: Int
    var luggageCapacity: Int
    var body: some View {
        HStack {
            CapacityCard(iconName: "kh_uisdk_passenger_capacity_icon", value: passangerCapacity)
            CapacityCard(iconName: "kh_uisdk_luggage_icon", value: luggageCapacity)
        }
    }
    
    struct CapacityCard: View {
        var iconName: String
        var value: Int
        var body: some View {
            HStack {
                Group {
                    Image(uiImage: .uisdkImage(iconName))
                        .renderingMode(.template)
                        .frame(
                            width: UIConstants.Dimension.Icon.small,
                            height: UIConstants.Dimension.Icon.small
                        )
                        .foregroundColor(Color(KarhooUI.colors.text))
                    Text("\(value)")
                        .font(Font(KarhooUI.fonts.footnoteSemiold()))
                        .foregroundColor(Color(KarhooUI.colors.text))
                }
            }
            .padding(UIConstants.Spacing.xSmall)
            .background(
                RoundedRectangle(cornerRadius: UIConstants.CornerRadius.xSmall)
                    .fill(Color(KarhooUI.colors.background1))
            )
        }
    }
}

struct NewVehicleCapacity_Previews: PreviewProvider {
    static var previews: some View {
        NewVehicleCapacity(passangerCapacity: 5, luggageCapacity: 4)
    }
}
