//
//  BookingConfirmationBuilder.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 15/12/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

public protocol BookingConfirmationBuilder {
    func buildBookingConfirmation(
        journeyDetails: JourneyDetails,
        tripInfo: TripInfo,
        quote: Quote,
        loyaltyInfo: KarhooBasicLoyaltyInfo?
    ) -> Screen
}

public extension BookingConfirmationBuilder {
    func buildBookingConfirmation(
        journeyDetails: JourneyDetails,
        tripInfo: TripInfo,
        quote: Quote
    ) -> Screen {
        buildBookingConfirmation(
            journeyDetails: journeyDetails,
            tripInfo: tripInfo,
            quote: quote,
            loyaltyInfo: .loyaltyDisabled()
        )
    }

    func buildBookingConfirmation(
        journeyDetails: JourneyDetails,
        tripInfo: TripInfo,
        quote: Quote,
        loyaltyInfo: KarhooBasicLoyaltyInfo?
    ) -> Screen {
        var callToDismiss: (() -> Void)?

        let sheetViewModel = KarhooBottomSheetViewModel(
            title: UITexts.Booking.prebookConfirmed,
            onDismissCallback: {
                callToDismiss?()
            }
        )

        let contentViewModel = KarhooBookingConfirmationViewModel(
            journeyDetails: journeyDetails,
            quote: quote,
            trip: tripInfo,
            loyaltyInfo: loyaltyInfo ?? .loyaltyDisabled(),
            onDismissCallback: { }
        )

        let screenBuilder = UISDKScreenRouting.default.bottomSheetScreen()
        let sheet = screenBuilder.buildBottomSheetScreenBuilderForUIKit(viewModel: sheetViewModel) {
            KarhooBookingConfirmationView(viewModel: contentViewModel)
        }

        callToDismiss = {
            sheet.dismiss(animated: true)
        }
        return sheet
    }
}

final class KarhooBookingConfirmationBuilder: BookingConfirmationBuilder {
}
