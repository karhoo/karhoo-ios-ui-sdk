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
    private let loyaltyPreAuthWorker: LoyaltyPreAuthWorker
    private let analytics: Analytics

    // MARK: - Properties

    // MARK: Internal properties

    var isLoyaltyEnabled: Bool { getIsLoyaltyEnabled() }
    var currentBalanceSubject = CurrentValueSubject<Int?, Never>(nil)

    // MARK: Private properties

    // MARK: - Lifecycle

    init(
        userService: UserService = Karhoo.getUserService(),
        loyaltyService: LoyaltyService = Karhoo.getLoyaltyService(),
        loyaltyPreAuthWorker: LoyaltyPreAuthWorker = KarhooLoyaltyPreAuthWorker()
        analytics: Analytics = KarhooUISDKConfigurationProvider.configuration.analytics()
    ) {
        self.userService = userService
        self.loyaltyService = loyaltyService
        self.analytics = analytics
    }
    // MARK: - Endpoints

    func getLoyaltyNonce(completion: @escaping (Result<LoyaltyNonce>) -> Void) {
        loyaltyPreAuthWorker(completion: completion)
    }

    // MARK: - Helpers

    private func getIsLoyaltyEnabled() -> Bool {
        let loyaltyId = userService.getCurrentUser()?.paymentProvider?.loyaltyProgamme.id
        return loyaltyId != nil && !loyaltyId!.isEmpty && LoyaltyFeatureFlags.loyaltyEnabled
    }
    private func loyaltyId() -> String? {
        userService.getCurrentUser()?.paymentProvider?.loyaltyProgamme.id
    }

}
