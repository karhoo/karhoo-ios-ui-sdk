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

    private lazy var guestBookingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Guest Booking Flow", for: .normal)
        button.tintColor = .blue

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var authenticatedBookingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Authenticated Booking Flow", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var tokenExchangeBookingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Token Exchange Booking Flow", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        guestBookingButton.addTarget(self, action: #selector(guestBookingTapped),
                                     for: .touchUpInside)
        authenticatedBookingButton.addTarget(self, action: #selector(authenticatedBookingTapped),
                                       for: .touchUpInside)
        tokenExchangeBookingButton.addTarget(self, action: #selector(tokenExchangeBookingTapped),
                                             for: .touchUpInside)
    }

    override func loadView() {
        super.loadView()

        [guestBookingButton, authenticatedBookingButton, tokenExchangeBookingButton].forEach { button in
            self.view.addSubview(button)
        }

        guestBookingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        guestBookingButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        authenticatedBookingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        authenticatedBookingButton.topAnchor.constraint(equalTo: guestBookingButton.bottomAnchor,
                                                        constant: -100).isActive = true

        tokenExchangeBookingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tokenExchangeBookingButton.topAnchor.constraint(equalTo: authenticatedBookingButton.bottomAnchor,
                                                        constant: -100).isActive = true
    }

    @objc func guestBookingTapped(sender: UIButton) {
        let guestSettings = GuestSettings(identifier: Keys.braintreeGuestIdentifier,
                                          referer: Keys.referer,
                                          organisationId: Keys.braintreeGuestOrganisationId)
        KarhooConfig.auth = .guest(settings: guestSettings)
        showKarhoo()
    }

    @objc func authenticatedBookingTapped(sender: UIButton) {
        KarhooConfig.auth = .karhooUser
        usernamePasswordLoginAndShowKarhoo()
    }

    @objc func tokenExchangeBookingTapped(sender: UIButton) {
        let tokenExchangeSettings = TokenExchangeSettings(clientId: Keys.braintreeTokenClientId, scope: Keys.braintreeTokenScope)
        KarhooConfig.auth = .tokenExchange(settings: tokenExchangeSettings)
        tokenLoginAndShowKarhoo()
    }

    private func usernamePasswordLoginAndShowKarhoo() {
        KarhooConfig.auth = .karhooUser
        let userService = Karhoo.getUserService()
        userService.logout().execute(callback: { _ in})
        
        let userLogin = UserLogin(username: Keys.userServiceEmailBraintree,
                                  password: Keys.userServicePasswordBraintree)
        userService.login(userLogin: userLogin).execute(callback: { result in
                                                print("login: \(result)")
                                                if result.isSuccess() {
                                                    self.showKarhoo()
                                                }
        })
    }

    private func tokenLoginAndShowKarhoo() {
        let authService = Karhoo.getAuthService()

        authService.login(token: Keys.braintreeAuthToken).execute { result in
            print("token login: \(result)")
            if result.isSuccess() {
                self.showKarhoo()
            }
        }
    }

    func showKarhoo() {
        var journeyInfo: JourneyInfo? = nil
        var passangerDetails: PassengerDetails? = nil

//        let originLat = CLLocationDegrees(Double(51.500869))
//        let originLon = CLLocationDegrees(Double(-0.124979))
//        let destLat = CLLocationDegrees(Double(51.502159))
//        let destLon = CLLocationDegrees(Double(-0.142040))
//
//        journeyInfo = JourneyInfo(origin: CLLocation(latitude: originLat, longitude: originLon),
//                                                     destination: CLLocation(latitude: destLat, longitude: destLon))
//
//        passangerDetails = PassengerDetails(firstName: "Name",
//                            lastName: "Lastname",
//                            email: "test@karhoo.com",
//                            phoneNumber: "+15005550006",
//                            locale: "en")

        booking = KarhooUI().screens().booking().buildBookingScreen(journeyInfo: journeyInfo,
                                         passengerDetails: passangerDetails,
                                         callback: { [weak self] result in
                                          switch result {
                                          case .completed(let bookingScreenResult):
                                            switch bookingScreenResult {
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
