//
//  ViewController.swift
//  Client
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooUISDK
import CoreLocation
import KarhooSDK

class ViewController: UIViewController {

    private var booking: Screen?

    private lazy var authenticatedBraintreeBookingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Authenticated Booking Flow [Braintree]", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var guestBraintreeBookingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Guest Booking Flow [Braintree]", for: .normal)
        button.tintColor = .blue

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var tokenExchangeBraintreeBookingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Token Exchange Booking Flow [Braintree]", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var authenticatedAdyenBookingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Authenticated Booking Flow [Adyen]", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var guestAdyenBookingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Guest Booking Flow [Adyen]", for: .normal)
        button.tintColor = .blue

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var tokenExchangeAdyenBookingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Token Exchange Booking Flow [Adyen]", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        authenticatedBraintreeBookingButton.addTarget(self, action: #selector(authenticatedBraintreeBookingTapped),
                                       for: .touchUpInside)
        guestBraintreeBookingButton.addTarget(self, action: #selector(guestBraintreeBookingTapped),
                                     for: .touchUpInside)
        tokenExchangeBraintreeBookingButton.addTarget(self, action: #selector(tokenExchangeBraintreeBookingTapped),
                                             for: .touchUpInside)
        authenticatedAdyenBookingButton.addTarget(self, action: #selector(authenticatedAdyenBookingTapped),
                                       for: .touchUpInside)
        guestAdyenBookingButton.addTarget(self, action: #selector(guestAdyenBookingTapped),
                                     for: .touchUpInside)
        tokenExchangeAdyenBookingButton.addTarget(self, action: #selector(tokenExchangeAdyenBookingTapped),
                                             for: .touchUpInside)
    }

    override func loadView() {
        super.loadView()

        [authenticatedBraintreeBookingButton, guestBraintreeBookingButton, tokenExchangeBraintreeBookingButton,
         authenticatedAdyenBookingButton, guestAdyenBookingButton, tokenExchangeAdyenBookingButton].forEach { button in
            self.view.addSubview(button)
        }
        
        authenticatedBraintreeBookingButton.centerX(inView: view)
        authenticatedBraintreeBookingButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 80)
        
        guestBraintreeBookingButton.centerX(inView: view)
        guestBraintreeBookingButton.anchor(top: authenticatedBraintreeBookingButton.bottomAnchor, paddingTop: 30)

        tokenExchangeBraintreeBookingButton.centerX(inView: view)
        tokenExchangeBraintreeBookingButton.anchor(top: guestBraintreeBookingButton.bottomAnchor, paddingTop: 30)

        authenticatedAdyenBookingButton.centerX(inView: view)
        authenticatedAdyenBookingButton.anchor(top: tokenExchangeBraintreeBookingButton.bottomAnchor, paddingTop: 80)

        guestAdyenBookingButton.centerX(inView: view)
        guestAdyenBookingButton.anchor(top: authenticatedAdyenBookingButton.bottomAnchor, paddingTop: 30)

        tokenExchangeAdyenBookingButton.centerX(inView: view)
        tokenExchangeAdyenBookingButton.anchor(top: guestAdyenBookingButton.bottomAnchor, paddingTop: 30)

    }

    @objc func guestAdyenBookingTapped(sender: UIButton) {
        let guestSettings = GuestSettings(identifier: Keys.adyenGuestIdentifier,
                                          referer: Keys.referer,
                                          organisationId: Keys.adyenGuestOrganisationId)
        KarhooConfig.auth = .guest(settings: guestSettings)
        KarhooConfig.environment = .sandbox
        showKarhoo()
    }

    @objc func guestBraintreeBookingTapped(sender: UIButton) {
        let guestSettings = GuestSettings(identifier: Keys.braintreeGuestIdentifier,
                                          referer: Keys.referer,
                                          organisationId: Keys.braintreeGuestOrganisationId)
        KarhooConfig.auth = .guest(settings: guestSettings)
        KarhooConfig.environment = .sandbox
        showKarhoo()
    }

    @objc func authenticatedAdyenBookingTapped(sender: UIButton) {
        KarhooConfig.auth = .karhooUser
        KarhooConfig.environment = .sandbox
        usernamePasswordLoginAndShowKarhoo(username: Keys.userServiceEmailAdyen, password: Keys.userServicePasswordAdyen)
    }
    
    @objc func authenticatedBraintreeBookingTapped(sender: UIButton) {
        KarhooConfig.auth = .karhooUser
        KarhooConfig.environment = .sandbox
        usernamePasswordLoginAndShowKarhoo(username: Keys.userServiceEmailBraintree, password: Keys.userServicePasswordBraintree)
    }

    @objc func tokenExchangeBraintreeBookingTapped(sender: UIButton) {
        let tokenExchangeSettings = TokenExchangeSettings(clientId: Keys.braintreeTokenClientId, scope: Keys.braintreeTokenScope)
        KarhooConfig.auth = .tokenExchange(settings: tokenExchangeSettings)
        KarhooConfig.environment = Keys.staging()
        tokenLoginAndShowKarhoo(token: Keys.braintreeAuthToken)
    }

    @objc func tokenExchangeAdyenBookingTapped(sender: UIButton) {
        let tokenExchangeSettings = TokenExchangeSettings(clientId: Keys.adyenTokenClientId, scope: Keys.adyenTokenScope)
        KarhooConfig.auth = .tokenExchange(settings: tokenExchangeSettings)
        KarhooConfig.environment = Keys.staging()
        tokenLoginAndShowKarhoo(token: Keys.adyenAuthToken)
    }

    private func usernamePasswordLoginAndShowKarhoo(username: String, password: String) {
        let userService = Karhoo.getUserService()
        userService.logout().execute(callback: { _ in})
        
        let userLogin = UserLogin(username: username,
                                  password: password)
        userService.login(userLogin: userLogin).execute(callback: { result in
                                                print("login: \(result)")
                                                if result.isSuccess() {
                                                    self.showKarhoo()
                                                }
        })
    }

    private func tokenLoginAndShowKarhoo(token: String) {
        let authService = Karhoo.getAuthService()

        authService.login(token: token).execute { result in
            print("token login: \(result)")
            if result.isSuccess() {
                self.showKarhoo()
            }
        }
    }

    func showKarhoo() {
        booking = KarhooUI().screens().booking().buildBookingScreen(journeyInfo: nil,
                                                                    passengerDetails: nil,
                                                                    callback: { [weak self] result in
                                                                        switch result {
                                                                        case .completed(let result):
                                                                            switch result {
                                                                            case .tripAllocated(let trip): (self?.booking as? BookingScreen)?.openTrip(trip)
                                                                            default: break
                                                                            }
                                                                        default: break
                                                                        }
                                                                    }) as? BookingScreen

        self.present(booking!,
                     animated: true,
                     completion: nil)
    }

    private func logout() {
        if Karhoo.configuration.authenticationMethod().isGuest() {
            return
        }

        Karhoo.getUserService().logout().execute(callback: { _ in})
    }
}
