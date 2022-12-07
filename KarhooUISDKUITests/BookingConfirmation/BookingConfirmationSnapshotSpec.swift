//
//  BookingConfirmationSnapshotSpec.swift
//  KarhooUISDKUITests
//
//  Created by Aleksander Wedrychowski on 02/12/2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Quick
import Nimble
import SnapshotTesting
import SwiftUI
import KarhooSDK
import KarhooUISDKTestUtils
@testable import KarhooUISDK

class BookingConfirmationSnapshotSpec: QuickSpec {

    override func spec() {

        describe("BookingConfirmation") {
            var uikitWrapper: UIViewController!
            var bottomSheet: KarhooBottomSheet<KarhooBookingConfirmationView>?
            var sut: KarhooBookingConfirmationView!
            var viewModel: BookingConfirmationViewModel!

            beforeEach {
                KarhooUI.set(configuration: KarhooTestConfiguration())
                viewModel = KarhooBookingConfirmationViewModel(
                    journeyDetails: .init(
                        originLocationDetails: .init(
                            timeZoneIdentifier: TimeZone(identifier: "Europe/Paris")!.identifier,
                            address: .init(displayAddress: "Origin display address", city: "OriginCity", postalCode: "12-345", countryCode: "FR")
                        ),
                        destinationLocationDetails: .init(address: .init(displayAddress: "Destination display address", city: "DestinationCity", postalCode: "12-345", countryCode: "FR")),
                        scheduledDate: .mock()
                    ),
                    quote: .init(price: .init(highPrice: 20, lowPrice: 10, currencyCode: "EUR", net: .init(high: 22, low: 11), intLowPrice: 12, intHighPrice: 23), validity: 300),
                    trip: TripInfo(dateScheduled: .mock()),
                    loyaltyInfo: KarhooBookingConfirmationLoyaltyInfo(
                        shouldShowLoyalty: true,
                        loyaltyPoints: 10,
                        loyaltyMode: .earn
                    ),
                    callback: { }
                )
                sut = KarhooBookingConfirmationView(viewModel: viewModel)
                bottomSheet = KarhooBottomSheet(
                    viewModel: KarhooBottomSheetViewModel(
                        title: UITexts.Booking.prebookConfirmed,
                        onDismissCallback: {}
                    ),
                    content: { sut! }
                )
                uikitWrapper = UIHostingController(rootView: bottomSheet).then {
                    $0.loadViewIfNeeded()
                    $0.view.translatesAutoresizingMaskIntoConstraints = false
                }
            }

            context("when it's showned") {

                it("should have a valid design") {
                    testSnapshot(uikitWrapper)
                }
            }
        }
    }
}
