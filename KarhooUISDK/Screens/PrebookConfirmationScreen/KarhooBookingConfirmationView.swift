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
        VStack(spacing: UIConstants.Spacing.standard) {
            // Icons
            iconView
            
            // Address
            KarhooAddressView(
                pickUp: KarhooAddressView.AddressLabel(
                    text: viewModel.printedPickUpAddressLine1,
                    subtext: viewModel.printedPickUpAddressLine2
                ),
                destination: KarhooAddressView.AddressLabel(
                    text: viewModel.printedDropOffAddressLine1,
                    subtext: nil //viewModel.printedDropOffAddressLine2
                ),
                design: .borderedWithWhiteBackground
            )
            
            // Time and Price
            timeAndPriceView
            
            // Loyalty
            if viewModel.loyaltyInfo.shouldShowLoyalty {
                KarhooLoyaltyInformationView(
                    viewModel: KarhooLoyaltyInformationView.ViewModel(
                        mode: viewModel.loyaltyInfo.loyaltyMode,
                        pointsToBeModified: viewModel.loyaltyInfo.loyaltyPoints
                    )
                )
            }

            if viewModel.useCalendar {
                // Add to calendar
                KarhooAddToCalendarView(
                    viewModel: KarhooAddToCalendarView.ViewModel(
                        onAddAction: { calendarViewModel in
                            viewModel.onAddToCalendar(viewModel: calendarViewModel)
                        }
                    )
                )
            }
            
            // Done button
            KarhooMainButton(title: UITexts.Booking.prebookConfirmedRideDetails) {
                viewModel.dismiss()
            }
        }
        .padding(.vertical, UIConstants.Spacing.standard)
    }

    @ViewBuilder
    private var iconView: some View {
        HStack(alignment: .top, spacing: 0) {
            Image(uiImage: UIImage.uisdkImage("kh_uisdk_check_circle"))
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
    }

    @ViewBuilder
    private var timeAndPriceView: some View {
        HStack {
            VStack {
                Text(viewModel.printedTime)
                    .font(Font(KarhooUI.fonts.titleBold()))
                    .foregroundColor(KarhooUI.colors.text.getColor())

                Text(viewModel.printedDate)
                    .font(Font(KarhooUI.fonts.bodyRegular()))
                    .foregroundColor(KarhooUI.colors.text.getColor())
            }
            .frame(minWidth: 0, maxWidth: .infinity)

            Rectangle()
                .fill(KarhooUI.colors.border.getColor())
                .frame(width: 1, height: Constants.separatorHeight, alignment: .center)

            VStack {
                Text(viewModel.printedPrice)
                    .font(Font(KarhooUI.fonts.titleBold()))
                    .foregroundColor(KarhooUI.colors.text.getColor())

                Text(viewModel.printedPriceType)
                    .font(Font(KarhooUI.fonts.bodyRegular()))
                    .foregroundColor(KarhooUI.colors.text.getColor())
            }
            .frame(minWidth: 0, maxWidth: .infinity)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}

struct KarhooBookingConfirmationViewPreviews: PreviewProvider {
    static var previews: some View {
        KarhooBookingConfirmationView(viewModel: KarhooBookingConfirmationViewModel(
            journeyDetails: JourneyDetails(),
            quote: Quote(),
            trip: TripInfo(),
            loyaltyInfo: KarhooBookingConfirmationViewModel.LoyaltyInfo(
                shouldShowLoyalty: true,
                loyaltyPoints: 25,
                loyaltyMode: .burn
            ),
            dateFormatter: KarhooDateFormatter(),
            callback: {

            })
        )
    }
}

struct KarhooMainButton: View {
    @State var title: String
    @State var callback: () -> Void
    
    var body: some View {
        Button(
            action: {
                callback()
            },
            label: {
                Text(title)
                .font(Font(KarhooUI.fonts.headerBold()))
                .foregroundColor(KarhooUI.colors.white.getColor())
                .frame(maxWidth: .infinity)
                .frame(height: UIConstants.Dimension.Button.mainActionButtonHeight)
                .background(KarhooUI.colors.secondary.getColor())
                .addBorder(.clear, cornerRadius: UIConstants.CornerRadius.medium)
            }
        )
    }
}
