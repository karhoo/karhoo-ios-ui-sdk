//
//  VehicleDetailsCard.swift
//  
//
//  Created by Bartlomiej Sopala on 11/01/2023.
//

import SwiftUI

struct VehicleDetailsCard: View {
    var body: some View {
        HStack(alignment: .center, spacing: UIConstants.Spacing.small) {
//            Image(uiImage: UIImage.uisdkImage("kh_uisdk_luggage_icon"))
            Color.red
                .frame(width: 80, height: 80)
                .scaledToFit()
            VStack(alignment: .leading, spacing: UIConstants.Spacing.small) {
                Text("Sedan (Standard)")
                    .font(Font(KarhooUI.fonts.headerSemibold()))
                    .foregroundColor(KarhooUI.colors.text.getColor())
                NewVehicleCapacity(passangerCapacity: 4, luggageCapacity: 5)
                HStack(spacing: UIConstants.Spacing.small) {
//                    Image(uiImage: .uisdkImage(iconName))
                    Color.blue
                        .frame(
                            width: UIConstants.Dimension.Icon.medium,
                            height: UIConstants.Dimension.Icon.medium
                        )
                    Text("Alpha taxi")
                        .font(Font(KarhooUI.fonts.captionSemibold()))
                        .foregroundColor(KarhooUI.colors.text.getColor())
                    
                    
                }
                
            }
            Spacer()
            
                
        }.padding(UIConstants.Spacing.standard)
    }
}

struct VehicleDetailsCard_Previews: PreviewProvider {
    static var previews: some View {
        VehicleDetailsCard()
    }
}

struct NewVehicleCapacity: View {
    var passangerCapacity: Int
    var luggageCapacity: Int
    var body: some View {
        HStack {
            CapacityCard(iconName: "kh_uisdk_passenger_capacity_icon", value: 4)
            CapacityCard(iconName: "kh_uisdk_luggage_icon", value: 5)
        }
    }
    
    struct CapacityCard: View {
        var iconName: String
        var value: Int
        var body: some View {
            HStack {
                Group {
                    Image(uiImage: .uisdkImage(iconName))
                        .frame(
                            width: UIConstants.Dimension.Icon.small,
                            height: UIConstants.Dimension.Icon.small
                        )
                    Text("\(value)")
                        .font(Font(KarhooUI.fonts.footnoteSemiold()))
                        .foregroundColor(KarhooUI.colors.text.getColor())
                }
            }
            .padding(UIConstants.Spacing.xSmall)
            .background(
                RoundedRectangle(cornerRadius: UIConstants.CornerRadius.xSmall)
                    .fill(KarhooUI.colors.background1.getColor())
            )
        }
    }
    
}
