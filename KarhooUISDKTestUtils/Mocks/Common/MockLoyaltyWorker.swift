//
//  MockLoyaltyWorker.swift
//  KarhooUISDKTestUtils
//
//  Created by Aleksander Wedrychowski on 07/02/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import Combine
import KarhooSDK
@testable import KarhooUISDK

public class MockLoyaltyWorker: LoyaltyWorker {
    public init() {}
    public var isLoyaltyEnabled: Bool = false
    public var modelSubject: CurrentValueSubject<Result<LoyaltyUIModel?>, Never> = CurrentValueSubject(.success(result: nil))
    public var modeSubject: CurrentValueSubject<LoyaltyMode, Never> = CurrentValueSubject(.none)

    public var setupCalled = false
    public func setup(using quote: Quote) {
        setupCalled = true
    }

    public var getLoyaltyNonceCalled = false
    public var getLoyaltyNonceResult: Result<LoyaltyNonce> = .success(result: LoyaltyNonce(loyaltyNonce: ""), correlationId: "")
    public func getLoyaltyNonce(completion: @escaping (Result<LoyaltyNonce>) -> Void) {
        getLoyaltyNonceCalled = true 
        completion(getLoyaltyNonceResult)
    }

    public var getBasicLoyaltyInfoToReturn: KarhooUISDK.KarhooBasicLoyaltyInfo = .init(shouldShowLoyalty: false, loyaltyPoints: 0, loyaltyMode: .none)
    public func getBasicLoyaltyInfo() -> KarhooUISDK.KarhooBasicLoyaltyInfo {
        getBasicLoyaltyInfoToReturn
    }
}
