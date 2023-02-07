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
    init() {}
    public var invalidateCallCount = 0
    public func invalidate() {
        invalidateCallCount += 1
    }

    public var setQuoteValidityDeadlineCallCount = 0
    public var setQuoteValidityDeadlineReceivedArguments: (quote: Quote, deadlineCompletion: () -> Void)? = nil
    public func setQuoteValidityDeadline(
        _ quote: Quote,
        deadlineCompletion: @escaping () -> Void
    ) {
        setQuoteValidityDeadlineCallCount += 1
        setQuoteValidityDeadlineReceivedArguments = (quote: quote, deadlineCompletion: deadlineCompletion)
    }
}

