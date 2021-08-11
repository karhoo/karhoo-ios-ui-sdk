//
//  KarhooComponents.swift
//  KarhooUISDK
//
//  Created by Jeevan Thandi on 05/05/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

public class KarhooComponents: BookingScreenComponents {

    public static let shared = KarhooComponents()

    public func addressBar(journeyInfo: JourneyInfo?) -> AddressBarView {
        let presenter = BookingAddressBarPresenter()

        let addressBarView = KarhooAddressBarView(cornerRadious: 3.0,
                                                  borderLine: true,
                                                  dropShadow: false,
                                                  verticalPadding: 5.0,
                                                  horizontalPadding: 5.0,
                                                  hidePickUpDestinationConnector: true)

        addressBarView.set(presenter: presenter)
        presenter.load(view: addressBarView)

        if let journey = journeyInfo {
            KarhooBookingStatus.shared.setJourneyInfo(journeyInfo: journey)
        }

        return addressBarView
    }

    public func quoteList() -> QuoteListView {
        let view = KarhooQuoteListViewController()
        return view
    }
}
