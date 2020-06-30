//
//  MockQuoteService.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

final class MockQuoteService: QuoteService {

    let quotesPollCall = MockPollCall<Quotes>()
    var quoteSearchSet: QuoteSearch?
    func quotes(quoteSearch: QuoteSearch) -> PollCall<Quotes> {
        quoteSearchSet = quoteSearch
        return quotesPollCall
    }
}
