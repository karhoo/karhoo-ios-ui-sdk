//
//  MockLoyaltyWorker.swift
//  KarhooUISDKTestUtils
//
//  Created by Bartlomiej Sopala on 08/02/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import Combine
import KarhooSDK
@testable import KarhooUISDK

final public class MockLoyaltyWorker: LoyaltyWorker {
    
    public init() { }
    
    public var isLoyaltyEnabled: Bool = true
    public var modelSubject = CurrentValueSubject<Result<LoyaltyUIModel?>, Never>(.success(result: nil))
    public var modeSubject = CurrentValueSubject<LoyaltyMode, Never>(.none)
    
    public func setup(using quote: Quote) { }
    public func getLoyaltyNonce(completion: @escaping (Result<LoyaltyNonce>) -> Void) { }
}
