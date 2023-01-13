//
//  VehicleDetailsCard.swift
//  
//
//  Created by Bartlomiej Sopala on 11/01/2023.
//

import SwiftUI

struct VehicleDetailsCard: View {
    
    let viewModel: VehicleDetailsCardViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: UIConstants.Spacing.small) {
            HStack(alignment: .center, spacing: UIConstants.Spacing.small) {
                KarhooAsyncImage(urlString: viewModel.carIconUrl)
                    .frame(width: 80, height: 80)
                    .scaledToFit()
                VStack(alignment: .leading, spacing: UIConstants.Spacing.xSmall) {
                    Text(viewModel.title)
                        .font(Font(KarhooUI.fonts.headerSemibold()))
                        .foregroundColor(KarhooUI.colors.text.getColor())
                    NewVehicleCapacity(
                        passangerCapacity: viewModel.passengerCapacity,
                        luggageCapacity: viewModel.luggageCapacity
                    )
                    HStack(spacing: UIConstants.Spacing.small) {
                        KarhooAsyncImage(urlString: viewModel.fleetIconUrl)
                            .frame(
                                maxWidth: UIConstants.Dimension.Icon.medium,
                                maxHeight: UIConstants.Dimension.Icon.medium
                            ).scaledToFill()
                            
                        Text(viewModel.fleetName)
                            .font(Font(KarhooUI.fonts.captionBold()))
                            .foregroundColor(KarhooUI.colors.text.getColor())
                    }
                }
                Spacer()
            }
            if let cancelationText = viewModel.cancelationText {
                Text(cancelationText)
                    .font(Font(KarhooUI.fonts.bodyRegular()))
                    .foregroundColor(KarhooUI.colors.text.getColor())
            }
        }
        .padding(UIConstants.Spacing.standard)
        .background(KarhooUI.colors.background2.getColor())
    }
}

struct VehicleDetailsCard_Previews: PreviewProvider {
    static var previews: some View {
        VehicleDetailsCard(
            viewModel: VehicleDetailsCardViewModel(
                title: "Sedan (Standard)",
                passengerCapacity: 4,
                luggageCapacity: 5,
                fleetName: "Alpha Taxi",
                carIconUrl: "kh_uisdk_supplier_logo_placeholder",
                fleetIconUrl: "kh_uisdk_supplier_logo_placeholder",
                cancelationText: "Free cancelaion up to 2 hours"
            )
        )
    }
}

struct VehicleDetailsCardViewModel {
    let title: String
    let passengerCapacity: Int
    let luggageCapacity: Int
    let fleetName: String
    let carIconUrl: String
    let fleetIconUrl: String
    let cancelationText: String?
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
