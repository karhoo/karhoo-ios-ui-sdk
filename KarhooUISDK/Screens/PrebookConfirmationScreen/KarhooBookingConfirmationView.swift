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
                    subtext: viewModel.printedDropOffAddressLine2
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
            KarhooMainButton(title: .constant(UITexts.Booking.prebookConfirmedRideDetails)) {
                viewModel.dismiss()
            }
            .accessibilityLabel(Text(UITexts.Booking.prebookConfirmedRideDetailsAccessibility))
        }
        .padding(.vertical, UIConstants.Spacing.standard)
        .onAppear {
            viewModel.onAppear()
        }
    }

    @ViewBuilder
    private var iconView: some View {
        HStack(alignment: .top, spacing: 0) {
            Image(uiImage: UIImage.uisdkImage("kh_uisdk_check_circle"))
                .frame(
                    width: UIConstants.Dimension.Icon.xLarge,
                    height: UIConstants.Dimension.Icon.xLarge
                )
                .accessibilityElement(children: .ignore)

            KarhooAsyncImage(urlString: viewModel.vehicleImageURL)
                .frame(
                    width: Constants.vehicleImageSize,
                    height: Constants.vehicleImageSize)
                .offset(x: Constants.vehicleImageXOffset)
                .accessibilityElement(children: .ignore)
        }
        .frame(height: UIConstants.Dimension.Icon.xxLarge)
        .accessibilityElement(children: .ignore)
    }

    @ViewBuilder
    private var timeAndPriceView: some View {
        HStack {
            VStack {
                Text(viewModel.printedTime)
                    .font(Font(KarhooUI.fonts.titleBold()))
                    .foregroundColor(Color(KarhooUI.colors.text))

                Text(viewModel.printedDate)
                    .font(Font(KarhooUI.fonts.bodyRegular()))
                    .foregroundColor(Color(KarhooUI.colors.textLabel))
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .accessibilityElement()
            .accessibilityValue(Text(viewModel.accessibilityDate))

            Rectangle()
                .fill(Color(KarhooUI.colors.border))
                .frame(width: 1, height: Constants.separatorHeight, alignment: .center)

            VStack {
                Text(viewModel.printedPrice)
                    .font(Font(KarhooUI.fonts.titleBold()))
                    .foregroundColor(Color(KarhooUI.colors.text))

                Text(viewModel.printedPriceType)
                    .font(Font(KarhooUI.fonts.bodyRegular()))
                    .foregroundColor(Color(KarhooUI.colors.textLabel))
                    .multilineTextAlignment(.center)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .accessibilityElement()
            .accessibilityValue(Text(viewModel.accessibilityPrice))
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
            loyaltyInfo: KarhooBasicLoyaltyInfo(
                shouldShowLoyalty: true,
                loyaltyPoints: 25,
                loyaltyMode: .burn
            ),
            dateFormatter: KarhooDateFormatter(),
            onDismissCallback: { _ in }
        ))
    }
}
