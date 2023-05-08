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
                    .accessibilityLabel(viewModel.carImageAccessibilityText)
                VStack(alignment: .leading, spacing: UIConstants.Spacing.xSmall) {
                    Text(viewModel.title)
                        .font(Font(KarhooUI.fonts.bodyBold()))
                        .foregroundColor(Color(KarhooUI.colors.text))
                    VehicleCapacity(
                        passangerCapacity: viewModel.passengerCapacity ?? 0,
                        luggageCapacity: viewModel.luggageCapacity ?? 0,
                        showPassengerCapacity: viewModel.passengerCapacity != nil,
                        showLuggageCapacity: viewModel.luggageCapacity != nil
                    )
                    HStack(spacing: UIConstants.Spacing.small) {
                        KarhooAsyncImage(urlString: viewModel.fleetIconUrl)
                            .frame(
                                maxWidth: UIConstants.Dimension.Icon.medium,
                                maxHeight: UIConstants.Dimension.Icon.medium
                            ).scaledToFill()
                            
                        Text(viewModel.fleetName)
                            .font(Font(KarhooUI.fonts.captionRegular()))
                            .foregroundColor(Color(KarhooUI.colors.text))
                    }
                    .accessibilityLabel(viewModel.fleetNameAccessibilityText)
                }
                Spacer()
            }
            if let cancelationText = viewModel.cancelationText {
                Text(cancelationText)
                    .font(Font(KarhooUI.fonts.captionRegular()))
                    .foregroundColor(Color(KarhooUI.colors.text))
            }
        }
        .padding(UIConstants.Spacing.standard)
        .background(Color(KarhooUI.colors.background2))
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
                cancelationText: "Free cancelaion up to 2 hours",
                carImageAccessibilityText: "Standard image"
            )
        )
    }
}

struct VehicleDetailsCardViewModel {
    let title: String
    let passengerCapacity: Int?
    let luggageCapacity: Int?
    let fleetName: String
    let carIconUrl: String
    let fleetIconUrl: String
    let cancelationText: String?
    let carImageAccessibilityText: String
    
    var fleetNameAccessibilityText: String {
        return "\(UITexts.Accessibility.fleetName), \(fleetName)"
    }
}
