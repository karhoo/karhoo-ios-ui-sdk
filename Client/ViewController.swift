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
#if canImport(KarhooUISDKAdyen)
import KarhooUISDKAdyen
#endif
#if canImport(KarhooUISDKBraintree)
import KarhooUISDKBraintree
#endif

public let notificationEnabledUserDefaultsKey = "notifications_enabled"

class ViewController: UIViewController {

    private var booking: Screen?
    private let defaults = UserDefaults.standard

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
    
    private lazy var loyaltyCanEarnTrueCanBurnTrueBookingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Loyalty +Earn +Burn [Adyen]", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var loyaltyCanEarnTrueCanBurnFalseBookingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Loyalty +Earn -Burn [Adyen]", for: .normal)
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
        authenticatedBraintreeBookingButton.addTarget(self, action: #selector(authenticatedBraintreeBookingTapped), for: .touchUpInside)
        guestBraintreeBookingButton.addTarget(self, action: #selector(guestBraintreeBookingTapped), for: .touchUpInside)
        tokenExchangeBraintreeBookingButton.addTarget(self, action: #selector(tokenExchangeBraintreeBookingTapped), for: .touchUpInside)
        authenticatedAdyenBookingButton.addTarget(self, action: #selector(authenticatedAdyenBookingTapped), for: .touchUpInside)
        guestAdyenBookingButton.addTarget(self, action: #selector(guestAdyenBookingTapped), for: .touchUpInside)
        tokenExchangeAdyenBookingButton.addTarget(self, action: #selector(tokenExchangeAdyenBookingTapped), for: .touchUpInside)
        loyaltyCanEarnTrueCanBurnTrueBookingButton.addTarget(self, action: #selector(loyaltyCanEarnTrueCanBurnTrueBookingTapped), for: .touchUpInside)
        loyaltyCanEarnTrueCanBurnFalseBookingButton.addTarget(self, action: #selector(loyaltyCanEarnTrueCanBurnFalseBookingTapped), for: .touchUpInside)
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
            authenticatedBraintreeBookingButton,
            guestBraintreeBookingButton,
            tokenExchangeBraintreeBookingButton,
            authenticatedAdyenBookingButton,
            guestAdyenBookingButton,
            tokenExchangeAdyenBookingButton,
            loyaltyCanEarnTrueCanBurnTrueBookingButton,
            loyaltyCanEarnTrueCanBurnFalseBookingButton,
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

    @objc func guestAdyenBookingTapped(sender: UIButton) {
        let guestSettings = GuestSettings(identifier: Keys.adyenGuestIdentifier,
                                          referer: Keys.referer,
                                          organisationId: Keys.adyenGuestOrganisationId)
        KarhooConfig.auth = .guest(settings: guestSettings)
        KarhooConfig.onUpdateAuthentication = { callback in
            KarhooConfig.auth = .guest(settings: guestSettings)
            callback() // Guest profile is not able to provide new user auth
        }
        KarhooConfig.environment = Keys.adyenGuestEnvironment
        KarhooConfig.paymentManager = AdyenPaymentManager()
        showKarhoo()
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
        showKarhoo()
    }

    @objc func authenticatedAdyenBookingTapped(sender: UIButton) {
        KarhooConfig.auth = .karhooUser
        KarhooConfig.onUpdateAuthentication = { callback in
            self.refreshUsernamePasswordLogin(
                username: Keys.adyenUserServiceEmail,
                password: Keys.adyenUserServicePassword,
                callback: callback
            )
        }
        KarhooConfig.environment = Keys.adyenUserServiceEnvironment
        KarhooConfig.paymentManager = AdyenPaymentManager()
        KarhooConfig.isExplicitTermsAndConditionsApprovalRequired = true
        usernamePasswordLoginAndShowKarhoo(
            username: Keys.adyenUserServiceEmail,
            password: Keys.adyenUserServicePassword
        )
    }
    
    @objc func authenticatedBraintreeBookingTapped(sender: UIButton) {
        KarhooConfig.auth = .karhooUser
        KarhooConfig.onUpdateAuthentication = { callback in
            self.refreshUsernamePasswordLogin(
                username: Keys.braintreeUserServiceEmail,
                password: Keys.braintreeUserServicePassword,
                callback: callback
            )
        }
        KarhooConfig.environment = Keys.braintreeUserServiceEnvironment
        KarhooConfig.paymentManager = BraintreePaymentManager()
        usernamePasswordLoginAndShowKarhoo(
            username: Keys.braintreeUserServiceEmail,
            password: Keys.braintreeUserServicePassword
        )
    }
    
    @objc func tokenExchangeBraintreeBookingTapped(sender: UIButton) {
        let tokenExchangeSettings = TokenExchangeSettings(clientId: Keys.braintreeTokenClientId, scope: Keys.braintreeTokenScope)
        KarhooConfig.auth = .tokenExchange(settings: tokenExchangeSettings)
        KarhooConfig.onUpdateAuthentication = { callback in
            self.refreshTokenLogin(token: Keys.braintreeAuthToken, callback: callback)
        }
        KarhooConfig.environment = Keys.braintreeTokenEnvironment
        KarhooConfig.paymentManager = BraintreePaymentManager()
        tokenLoginAndShowKarhoo(token: Keys.braintreeAuthToken)
    }
    
    @objc func tokenExchangeAdyenBookingTapped(sender: UIButton) {
        let tokenExchangeSettings = TokenExchangeSettings(clientId: Keys.adyenTokenClientId, scope: Keys.adyenTokenScope)
        KarhooConfig.auth = .tokenExchange(settings: tokenExchangeSettings)
        KarhooConfig.onUpdateAuthentication = { callback in
            self.refreshTokenLogin(token: Keys.adyenAuthToken, callback: callback)
        }
        KarhooConfig.environment = Keys.adyenTokenEnvironment
        KarhooConfig.paymentManager = AdyenPaymentManager()
        tokenLoginAndShowKarhoo(token: Keys.adyenAuthToken)
    }
    
    @objc func loyaltyCanEarnTrueCanBurnTrueBookingTapped(sender: UIButton) {
        let tokenExchangeSettings = TokenExchangeSettings(clientId: Keys.loyaltyTokenClientId, scope: Keys.loyaltyTokenScope)
        KarhooConfig.auth = .tokenExchange(settings: tokenExchangeSettings)
        KarhooConfig.onUpdateAuthentication = { callback in
            self.refreshTokenLogin(token: Keys.loyaltyCanEarnTrueCanBurnTrueAuthToken, callback: callback)
        }
        KarhooConfig.environment = Keys.loyaltyTokenEnvironment
        KarhooConfig.paymentManager = AdyenPaymentManager()
        tokenLoginAndShowKarhoo(token: Keys.loyaltyCanEarnTrueCanBurnTrueAuthToken)
    }
    
    @objc func loyaltyCanEarnTrueCanBurnFalseBookingTapped(sender: UIButton) {
        let tokenExchangeSettings = TokenExchangeSettings(clientId: Keys.loyaltyTokenClientId, scope: Keys.loyaltyTokenScope)
        KarhooConfig.auth = .tokenExchange(settings: tokenExchangeSettings)
        KarhooConfig.onUpdateAuthentication = { callback in
            self.refreshTokenLogin(token: Keys.loyaltyCanEarnTrueCanBurnFalseAuthToken, callback: callback)
        }
        KarhooConfig.environment = Keys.loyaltyTokenEnvironment
        KarhooConfig.paymentManager = AdyenPaymentManager()
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
    
    private func refreshUsernamePasswordLogin(
        username: String,
        password: String,
        callback: @escaping () -> Void
    ) {
            let userService = Karhoo.getUserService()
            
            let userLogin = UserLogin(username: username,
                                      password: password)
            userService.login(userLogin: userLogin).execute(callback: { result in
                print("login: \(result)")
                if result.isSuccess() {
                    callback()
                }
            }
        )
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
                
            case .prebookConfirmed(let trip, let prebookConfirmationAction):
                if case .rideDetails = prebookConfirmationAction {
                    bookingScreen?.openRideDetailsFor(trip)
                }
                
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
