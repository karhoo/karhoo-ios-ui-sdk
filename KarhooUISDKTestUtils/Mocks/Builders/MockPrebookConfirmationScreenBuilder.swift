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

final public class MockPrebookConfirmationScreenBuilder: PrebookConfirmationScreenBuilder {

    public var quoteSet: Quote?
    public var journeyDetailsSet: JourneyDetails?
    private var confirmationCallbackSet: ScreenResultCallback<PrebookConfirmationAction>?
    public let prebookConfirmationScreenInstance = Screen()

    public func buildPrebookConfirmationScreen(quote: Quote,
                                        journeyDetails: JourneyDetails,
                                        confirmationCallback: @escaping ScreenResultCallback<PrebookConfirmationAction>) -> Screen {
        
        quoteSet = quote
        journeyDetailsSet = journeyDetails
        confirmationCallbackSet = confirmationCallback
        return prebookConfirmationScreenInstance
    }
    // swiftlint:enable line_length
    
    public func triggerScreenResult(_ result: ScreenResult<PrebookConfirmationAction>) {
        confirmationCallbackSet?(result)
    }
}
