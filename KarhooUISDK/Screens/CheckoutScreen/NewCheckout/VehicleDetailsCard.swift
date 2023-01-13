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
                        .font(Font(KarhooUI.fonts.captionSemibold()))
                        .foregroundColor(KarhooUI.colors.text.getColor())
                }
            }
            Spacer()    
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
                fleetIconUrl: "kh_uisdk_supplier_logo_placeholder"
            )
        )
    }
}
