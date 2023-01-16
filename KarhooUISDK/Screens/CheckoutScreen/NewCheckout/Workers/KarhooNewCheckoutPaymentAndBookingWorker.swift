//
//  KarhooNewCheckoutPaymentWorker.swift
//  KarhooUISDK
//
//  Created by Aleksander Wedrychowski on 12/01/2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
import UIKit
import SwiftUI
import Combine

enum CheckoutBookingError {
    case noUser
    case cardAuthenticationFailure(message: String?)
}

/// This is only on concept. Feel free to adjust it if needed.
enum BookingState {
    case idle
    case failure(CheckoutBookingError)
    case success
}

protocol NewCheckoutPaymentAndBookingWorker: AnyObject {
    var statePublisher : Published<BookingState>.Publisher { get }
    func isReadyToPerformPayment() -> Bool
    func performBooking()
    func getPaymentNonce() -> Nonce?
}

final class KarhooNewCheckoutPaymentAndBookingWorker: NewCheckoutPaymentAndBookingWorker {

    // MARK: - Depencencies

    private let userService: UserService
    private let sdkConfiguration: KarhooUISDKConfiguration
    private let analytics: Analytics

    // MARK: - Properties

    private var quote: Quote!
    private(set) var paymentNonce: Nonce?
    private(set) var loyaltyNonce: LoyaltyNonce?
    private(set) var passengerDetails: PassengerDetails?
    private(set) var bookingRequestInProgress = false

    var statePublisher: Published<BookingState>.Publisher { $bookingState }
    @Published var bookingState: BookingState = .idle

    // MARK: - Lifecycle

    init(
        userService: UserService = Karhoo.getUserService(),
        sdkConfiguration: KarhooUISDKConfiguration = KarhooUISDKConfigurationProvider.configuration,
        analytics: Analytics = KarhooUISDKConfigurationProvider.configuration.analytics()
    ) {
        self.userService = userService
        self.sdkConfiguration = sdkConfiguration
        self.analytics = analytics
    }

    // MARK: - Endpoints

    func isReadyToPerformPayment() -> Bool {
        false
    }

    func getPaymentNonce() -> Nonce? {
        paymentNonce
    }

    func performBooking() {

    }
}
