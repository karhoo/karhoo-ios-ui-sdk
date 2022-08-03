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
    let coverageCall = MockCall<QuoteCoverage>()
    let verifyQuoteCall = MockCall<Quote>()
    var quoteSearchSet: QuoteSearch?
    var quoteCoverageSet: QuoteCoverageRequest?
    var verifyQuoteSet: VerifyQuotePayload?
    var vehilcleImageRulesCall = MockCall<VehicleImageRules>()
    
    func quotes(quoteSearch: QuoteSearch) -> PollCall<Quotes> {
        quoteSearchSet = quoteSearch
        return quotesPollCall
    }

    func quotesV2(quoteSearch: QuoteSearch) -> PollCall<Quotes> {
        quoteSearchSet = quoteSearch
        return quotesPollCall
    }
    
    func coverage(coverageRequest: QuoteCoverageRequest) -> Call<QuoteCoverage> {
        quoteCoverageSet = coverageRequest
        return coverageCall
    }
    
    func verifyQuote(verifyQuotePayload: VerifyQuotePayload) -> Call<Quote> {
        verifyQuoteSet = verifyQuotePayload
        return verifyQuoteCall
    }

    func getVehicleImageRules() -> Call<VehicleImageRules> {
        vehilcleImageRulesCall
    }
}
