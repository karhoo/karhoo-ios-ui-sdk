//
//  PrebookConfirmationScreenFactory.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

internal protocol PrebookConfirmationScreenBuilder {
    func buildPrebookConfirmationScreen(quote: Quote,
                                        bookingDetails: JourneyDetails,
                                        confirmationCallback:
        @escaping ScreenResultCallback<PrebookConfirmationAction>) -> Screen
}
