//
//  NewVehicleCapacity.swift
//  KarhooUISDK
//
//  Created by Bartlomiej Sopala on 13/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI

public struct KHVehicleCapacityViewID {
    public static let capacityView = "vehicle_capacity_view"
    public static let baggageContentView = "baggage_content_view"
    public static let passengerCapacityContentView = "passenger_capacity_content_view"
    public static let baggageInfoView = "baggage_info_view"
    public static let baggageIcon = "baggage_image"
    public static let baggageCapacityLabel = "baggage_capacity_label"
    public static let capacityInfoView = "capacity_info_view"
    public static let capacityIcon = "passenger_capacity_image"
    public static let passengerCapacityLabel = "passenger_capacity_label"
    public static let additionalCapacityContentView = "additional_capabilities_content_view"
    public static let additionalFleetCapabilitiesView = "additional_capabilities_view"
    public static let additionalFleetCapabilitiesLabel = "additional_capabilities_label"
}

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
