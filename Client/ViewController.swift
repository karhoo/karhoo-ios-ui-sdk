//
//  ViewController.swift
//  Client
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import CoreLocation
import KarhooSDK
import KarhooUISDK
import UIKit
#if canImport(KarhooUISDKBraintree)
import KarhooUISDKBraintree
#endif

public let notificationEnabledUserDefaultsKey = "notifications_enabled"

class ViewController: UIViewController {

    private var booking: Screen?
    private let defaults = UserDefaults.standard
    
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
    
    private lazy var loyaltyCanEarnTrueCanBurnTrueBraintreeBookingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Loyalty +Earn +Burn [Braintree]", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var loyaltyCanEarnTrueCanBurnFalseBraintreeBookingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Loyalty +Earn -Burn [Braintree]", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var notificationsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        guestBraintreeBookingButton.addTarget(self, action: #selector(guestBraintreeBookingTapped), for: .touchUpInside)
        tokenExchangeBraintreeBookingButton.addTarget(self, action: #selector(tokenExchangeBraintreeBookingTapped), for: .touchUpInside)
        loyaltyCanEarnTrueCanBurnTrueBraintreeBookingButton.addTarget(self, action: #selector(loyaltyCanEarnTrueCanBurnTrueBraintreeBookingTapped), for: .touchUpInside)
        loyaltyCanEarnTrueCanBurnFalseBraintreeBookingButton.addTarget(self, action: #selector(loyaltyCanEarnTrueCanBurnFalseBraintreeBookingTapped), for: .touchUpInside)
        notificationsButton.addTarget(self, action: #selector(notificationsButtonTapped), for: .touchUpInside)
    }

    override func loadView() {
        super.loadView()
        
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.anchor(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            bottom: view.bottomAnchor
        )
        
        let stackView = UIStackView(arrangedSubviews: [
            guestBraintreeBookingButton,
            tokenExchangeBraintreeBookingButton,
            loyaltyCanEarnTrueCanBurnTrueBraintreeBookingButton,
            loyaltyCanEarnTrueCanBurnFalseBraintreeBookingButton,
            notificationsButton
        ])
        updateNotificationButtonLabel()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 30
        scrollView.addSubview(stackView)
        stackView.anchor(
            top: scrollView.topAnchor,
            leading: scrollView.leadingAnchor,
            trailing: scrollView.trailingAnchor,
            bottom: scrollView.bottomAnchor,
            paddingTop: 80,
            paddingLeft: 20,
            paddingRight: 20,
            paddingBottom: 20
        )
    }

    @objc func guestBraintreeBookingTapped(sender: UIButton) {
        let guestSettings = GuestSettings(identifier: Keys.braintreeGuestIdentifier,
                                          referer: Keys.referer,
                                          organisationId: Keys.braintreeGuestOrganisationId)
        KarhooConfig.auth = .guest(settings: guestSettings)
        KarhooConfig.onUpdateAuthentication = { callback in
            KarhooConfig.auth = .guest(settings: guestSettings)
            callback() // Guest profile is not able to provide new user auth
        }
        KarhooConfig.environment = Keys.braintreeGuestEnvironment
        KarhooConfig.paymentManager = BraintreePaymentManager()
        KarhooConfig.isExplicitTermsAndConditionsApprovalRequired = false
        showKarhoo()
    }
    
    @objc func tokenExchangeBraintreeBookingTapped(sender: UIButton) {
        let tokenExchangeSettings = TokenExchangeSettings(clientId: Keys.braintreeTokenClientId, scope: Keys.braintreeTokenScope)
        KarhooConfig.auth = .tokenExchange(settings: tokenExchangeSettings)
        KarhooConfig.onUpdateAuthentication = { callback in
            self.refreshTokenLogin(token: Keys.braintreeAuthToken, callback: callback)
        }
        KarhooConfig.paymentManager = BraintreePaymentManager()
        KarhooConfig.isExplicitTermsAndConditionsApprovalRequired = false
        tokenLoginAndShowKarhoo(token: Keys.braintreeAuthToken)
    }
    
    @objc func loyaltyCanEarnTrueCanBurnTrueBraintreeBookingTapped(sender: UIButton) {
        let tokenExchangeSettings = TokenExchangeSettings(clientId: Keys.loyaltyTokenBraintreeClientId, scope: Keys.loyaltyTokenScope)
        KarhooConfig.auth = .tokenExchange(settings: tokenExchangeSettings)
        KarhooConfig.onUpdateAuthentication = { callback in
            self.refreshTokenLogin(token: Keys.loyaltyCanEarnTrueCanBurnTrueAuthToken, callback: callback)
        }
        KarhooConfig.environment = Keys.loyaltyTokenEnvironment
        KarhooConfig.paymentManager = BraintreePaymentManager()
        KarhooConfig.isExplicitTermsAndConditionsApprovalRequired = true
        tokenLoginAndShowKarhoo(token: Keys.loyaltyCanEarnTrueCanBurnTrueAuthToken)
    }
    
    @objc func loyaltyCanEarnTrueCanBurnFalseBraintreeBookingTapped(sender: UIButton) {
        let tokenExchangeSettings = TokenExchangeSettings(clientId: Keys.loyaltyTokenBraintreeClientId, scope: Keys.loyaltyTokenScope)
        KarhooConfig.auth = .tokenExchange(settings: tokenExchangeSettings)
        KarhooConfig.onUpdateAuthentication = { callback in
            self.refreshTokenLogin(token: Keys.loyaltyCanEarnTrueCanBurnFalseAuthToken, callback: callback)
        }
        KarhooConfig.environment = Keys.loyaltyTokenEnvironment
        KarhooConfig.paymentManager = BraintreePaymentManager()
        KarhooConfig.isExplicitTermsAndConditionsApprovalRequired = true
        tokenLoginAndShowKarhoo(token: Keys.loyaltyCanEarnTrueCanBurnFalseAuthToken)
    }
    
    // MARK: Notifications
    
    @objc func notificationsButtonTapped(sender: UIButton){
        if notificationsEnabled {
            setUserDefaultsNotifiactions(enabled: false)
            updateNotificationButtonLabel()
        } else {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] success, error in
                if success {
                    self?.setUserDefaultsNotifiactions(enabled: true)
                    self?.updateNotificationButtonLabel()
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private var notificationsEnabled: Bool {
        return defaults.bool(forKey: notificationEnabledUserDefaultsKey)
    }
    
    private func setUserDefaultsNotifiactions(enabled: Bool) {
        defaults.set(enabled, forKey: notificationEnabledUserDefaultsKey)
    }
    
    func updateNotificationButtonLabel() {
        let label = "Notifications: " + (notificationsEnabled ? "ENABLED" : "DISABLED")
        DispatchQueue.main.async {
            self.notificationsButton.setTitle(label, for: .normal)
        }
    }

    private func tokenLoginAndShowKarhoo(token: String) {
        let authService = Karhoo.getAuthService()
        
        authService.login(token: token).execute { result in
            print("token login: \(result)")
            if result.isSuccess() {
                self.showKarhoo()
            } else {
                self.showLoginErrorAllert()
            }
        }
    }
    
    private func showLoginErrorAllert() {
        let alert = UIAlertController(
            title: "Login was unsuccessful",
            message: "Something went wrong during the login process. Either the servers are down or, more probably, the token used is expired.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func refreshTokenLogin(token: String, callback: @escaping () -> Void) {
        let authService = Karhoo.getAuthService()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            authService.login(token: token).execute { result in
                print("token login: \(result)")
                if result.isSuccess() {
                    callback()
                }
            }
         }
    }
    
    func showKarhoo() {
        let journeyInfo: JourneyInfo? = nil
        let passangerDetails: PassengerDetails? = nil
        
//        let originLat = CLLocationDegrees(Double(51.500869))
//        let originLon = CLLocationDegrees(Double(-0.124979))
//        let destLat = CLLocationDegrees(Double(51.502159))
//        let destLon = CLLocationDegrees(Double(-0.142040))
//
//        journeyInfo = JourneyInfo(
//            origin: CLLocation(latitude: originLat, longitude: originLon),
//            destination: CLLocation(latitude: destLat, longitude: destLon)
//        )
//
//        passangerDetails = PassengerDetails(firstName: "Name",
//                            lastName: "Lastname",
//                            email: "test@karhoo.com",
//                            phoneNumber: "+15005550006",
//                            locale: "en")
        
        booking = KarhooUI().screens().booking()
            .buildBookingScreen(
                journeyInfo: journeyInfo,
                passengerDetails: passangerDetails,
                callback: { [weak self] result in
                    self?.handleBookingScreenResult(result: result)
                }
            )

        self.present(
            booking!,
            animated: true,
            completion: nil
        )
    }

    private func handleBookingScreenResult(result: ScreenResult<BookingScreenResult>) {
        let bookingInNavigationStack = (booking as? UINavigationController)?.viewControllers.first { $0 is BookingScreen }
        let bookingScreen = (booking as? BookingScreen) ?? (bookingInNavigationStack as? BookingScreen)

        switch result {

        case .completed(let bookingScreenResult):
            switch bookingScreenResult {
                
            case .tripAllocated(let trip):
                bookingScreen?.openTrip(trip)
                
            case .prebookConfirmed(let trip):
                bookingScreen?.openRideDetailsFor(trip)
                
            default:
                break
            }
        default:
            break
        }
    }

    private func logout(callback: @escaping () -> Void = {}) {
        if Karhoo.configuration.authenticationMethod().isGuest() {
            return
        }

        Karhoo.getUserService().logout().execute { _ in callback() }
    }
}
