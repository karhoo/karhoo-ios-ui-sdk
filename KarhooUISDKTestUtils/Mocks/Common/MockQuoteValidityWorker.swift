//
//  MockQuoteValidityWorker.swift
//  KarhooUISDKTestUtils
//
//  Created by Aleksander Wedrychowski on 07/02/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
@testable import KarhooUISDK

public class MockQuoteValidityWorker: QuoteValidityWorker {
    public init() {}
    public var invalidateCalled = false
    public func invalidate() {
        invalidateCalled = true
    }

    public var setQuoteValidityDeadlineCalled = false
    public var setQuoteValidityDeadlineReceivedArguments: (quote: Quote, deadlineCompletion: () -> Void)? = nil
    public func setQuoteValidityDeadline(
        _ quote: Quote,
        deadlineCompletion: @escaping () -> Void
    ) {
        setQuoteValidityDeadlineCalled = true
        setQuoteValidityDeadlineReceivedArguments = (quote: quote, deadlineCompletion: deadlineCompletion)
    }
}

