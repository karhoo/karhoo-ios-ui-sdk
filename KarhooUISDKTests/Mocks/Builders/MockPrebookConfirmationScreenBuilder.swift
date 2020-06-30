//
//  MockPrebookConfirmationScreenFactory.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

@testable import KarhooUISDK

final class MockPrebookConfirmationScreenBuilder: PrebookConfirmationScreenBuilder {

    private(set) var quoteSet: Quote?
    private(set) var bookingDetailsSet: BookingDetails?
    private var confirmationCallbackSet: ScreenResultCallback<PrebookConfirmationAction>?
    let prebookConfirmationScreenInstance = Screen()

    func buildPrebookConfirmationScreen(quote: Quote,
                                        bookingDetails: BookingDetails,
                                        confirmationCallback: @escaping ScreenResultCallback<PrebookConfirmationAction>) -> Screen {
        
        quoteSet = quote
        bookingDetailsSet = bookingDetails
        confirmationCallbackSet = confirmationCallback
        return prebookConfirmationScreenInstance
    }
    // swiftlint:enable line_length
    
    func triggerScreenResult(_ result: ScreenResult<PrebookConfirmationAction>) {
        confirmationCallbackSet?(result)
    }
}
