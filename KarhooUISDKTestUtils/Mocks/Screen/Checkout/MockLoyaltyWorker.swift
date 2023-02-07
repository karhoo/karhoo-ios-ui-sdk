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
    public var isLoyaltyEnabled: Bool = false
    public var modelSubject: CurrentValueSubject<Result<LoyaltyUIModel?>, Never> = CurrentValueSubject(.success(result: nil))
    public var modeSubject: CurrentValueSubject<LoyaltyMode, Never> = CurrentValueSubject(.none)

    public func setup(using quote: Quote) {}

    public func getLoyaltyNonce(completion: @escaping (Result<LoyaltyNonce>) -> Void) {}
}
