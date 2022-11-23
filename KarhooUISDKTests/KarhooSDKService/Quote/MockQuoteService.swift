//
//  MockQuoteService.swift
//  KarhooTests
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

final public class MockQuoteService: QuoteService {
    public let quotesPollCall = MockPollCall<Quotes>()
     public let coverageCall = MockCall<QuoteCoverage>()
    public let verifyQuoteCall = MockCall<Quote>()
    public var quoteSearchSet: QuoteSearch?
    public var quoteCoverageSet: QuoteCoverageRequest?
    public var verifyQuoteSet: VerifyQuotePayload?
    public var vehilcleImageRulesCall = MockCall<VehicleImageRules>()

    public func quotes(quoteSearch: QuoteSearch) -> PollCall<Quotes> {
        quoteSearchSet = quoteSearch
        return quotesPollCall
    }

    public func quotesV2(quoteSearch: QuoteSearch) -> PollCall<Quotes> {
        quoteSearchSet = quoteSearch
        return quotesPollCall
    }
    
    public func coverage(coverageRequest: QuoteCoverageRequest) -> Call<QuoteCoverage> {
        quoteCoverageSet = coverageRequest
        return coverageCall
    }
    
    public func verifyQuote(verifyQuotePayload: VerifyQuotePayload) -> Call<Quote> {
        verifyQuoteSet = verifyQuotePayload
        return verifyQuoteCall
    }

    public func getVehicleImageRules() -> Call<VehicleImageRules> {
        vehilcleImageRulesCall
    }
}
