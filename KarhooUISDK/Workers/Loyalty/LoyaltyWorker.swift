//
//  LoyaltyWorker.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 26/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Combine
import KarhooSDK

protocol LoyaltyWorker: AnyObject {
    var isLoyaltyEnabled: Bool { get }
    var loyaltyIdSubject: CurrentValueSubject<String?, Never> { get }
    var currentBalanceSubject: CurrentValueSubject<Int?, Never> { get }

    func getLoyaltyNonce(completion: @escaping (Result<LoyaltyNonce>) -> Void)
}

final class KarhooLoyaltyWorker: LoyaltyWorker {

    // MARK: - Dependecies

    private let userService: UserService
    private var loyaltyService: LoyaltyService
    private let analytics: Analytics

    // MARK: - Properties

    // MARK: Internal properties

    var isLoyaltyEnabled: Bool { get }
    var loyaltyIdSubject: CurrentValueSubject<String?, Never> { get }
    var currentBalanceSubject: CurrentValueSubject<Int?, Never> { get }

    // MARK: Private properties

    // MARK: - Lifecycle

    init(
        userService: UserService = Karhoo.getUserService(),
        loyaltyService: LoyaltyService = Karhoo.getLoyaltyService(),
        analytics: Analytics = KarhooUISDKConfigurationProvider.configuration.analytics()
    ) {
        self.userService = userService
        self.loyaltyService = loyaltyService
        self.analytics = analytics
    }
    // MARK: - Endpoints

    func getLoyaltyNonce(completion: @escaping (Result<LoyaltyNonce>) -> Void) {
        assertionFailure()
        completion(.failure(error: nil))
    }

}
