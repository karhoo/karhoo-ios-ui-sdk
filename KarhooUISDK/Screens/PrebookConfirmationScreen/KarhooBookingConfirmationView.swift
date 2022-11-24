//
//  KarhooBookingConfirmationView.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 18.11.2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import SwiftUI
import KarhooSDK

struct KarhooBookingConfirmationView: View {
    enum Constants {
        static let vehicleImageSize: CGFloat = 80
        static let vehicleImageXOffset: CGFloat = -5
        static let separatorHeight: CGFloat = 50
    }
    
    // MARK: - Properties
    private var viewModel: BookingConfirmationViewModel
    
    // MARK: - Init
    init(viewModel: BookingConfirmationViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: UIConstants.Spacing.standard, content: {
            // Icons
            HStack(alignment: .top, spacing: 0) {
                Image(uiImage:  UIImage.uisdkImage("kh_uisdk_check_circle"))
                    .frame(
                        width: UIConstants.Dimension.Icon.xLarge,
                        height: UIConstants.Dimension.Icon.xLarge
                    )
                
                KarhooAsyncImage(urlString: viewModel.vehicleImageURL)
                    .frame(
                        width: Constants.vehicleImageSize,
                        height: Constants.vehicleImageSize)
                    .offset(x: Constants.vehicleImageXOffset)
            }
            .frame(height: UIConstants.Dimension.Icon.xxLarge)
            
            // Address
            
            // Time and Price
            HStack {
                VStack {
                    Text(viewModel.printedTime)
                        .font(Font(KarhooUI.fonts.titleBold()))
                    
                    Text(viewModel.printedDate)
                        .font(Font(KarhooUI.fonts.bodyRegular()))
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                
                Rectangle()
                    .fill(KarhooUI.colors.border.getColor())
                    .frame(width: 1, height: Constants.separatorHeight, alignment: .center)
                    
                VStack {
                    Text(viewModel.printedPrice)
                        .font(Font(KarhooUI.fonts.titleBold()))
                    
                    Text(viewModel.printedPriceType)
                        .font(Font(KarhooUI.fonts.bodyRegular()))
                }
                .frame(minWidth: 0, maxWidth: .infinity)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            
            // Loyalty
            if viewModel.shouldShowLoyalty {
            }
            
            // Add to calendar
            
            // Done button
            KarhooMainButton(title: UITexts.Booking.prebookConfirmedRideDetails) {
                viewModel.dismiss()
            }
        })
    }
}

struct KarhooBookingConfirmationViewPreviews: PreviewProvider {
    static var previews: some View {
        KarhooBookingConfirmationView(viewModel: KarhooBookingConfirmationViewModel(
            journeyDetails: JourneyDetails(),
            quote: Quote(),
            shouldShowLoyalty: true,
            callback: {
                
            }))
    }
}

struct KarhooMainButton: View {
    @State var title: String
    @State var callback: () -> Void
    
    var body: some View {
        ZStack {
            Text(title)
                .font(Font(KarhooUI.fonts.headerBold()))
                .foregroundColor(KarhooUI.colors.white.getColor())
                
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: UIConstants.Dimension.Button.mainActionButtonHeight)
        .background(KarhooUI.colors.secondary.getColor())
        .clipShape(
            RoundedRectangle(
                cornerRadius: UIConstants.CornerRadius.medium,
                style: .continuous
            )
        )
        .onTapGesture {
            callback()
        }
    }
}
