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
    
    private lazy var bookingFlowAsComponentsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Token exchange [Braintree] [Components]", for: .normal)
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
        bookingFlowAsComponentsButton.addTarget(self, action: #selector(bookingFlowAsComponentsTapped), for: .touchUpInside)
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
            bookingFlowAsComponentsButton,
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
        KarhooConfig.disablePrebookRides = false
        KarhooConfig.excludedFilterCategories = []
        KarhooConfig.disableCallDriverOrFleetFeature = false
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
        KarhooConfig.disablePrebookRides = false
        KarhooConfig.excludedFilterCategories = []
        KarhooConfig.disableCallDriverOrFleetFeature = false
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
        KarhooConfig.disablePrebookRides = false
        KarhooConfig.excludedFilterCategories = []
        KarhooConfig.disableCallDriverOrFleetFeature = false
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
        KarhooConfig.disablePrebookRides = false
        KarhooConfig.excludedFilterCategories = []
        KarhooConfig.disableCallDriverOrFleetFeature = false
        tokenLoginAndShowKarhoo(token: Keys.loyaltyCanEarnTrueCanBurnFalseAuthToken)
    }
    
    @objc func bookingFlowAsComponentsTapped(sender: UIButton) {
        let tokenExchangeSettings = TokenExchangeSettings(clientId: Keys.braintreeTokenClientId, scope: Keys.braintreeTokenScope)
        KarhooConfig.auth = .tokenExchange(settings: tokenExchangeSettings)
        KarhooConfig.onUpdateAuthentication = { callback in
            self.refreshTokenLogin(token: Keys.braintreeAuthToken, callback: callback)
        }
        KarhooConfig.paymentManager = BraintreePaymentManager()
        KarhooConfig.isExplicitTermsAndConditionsApprovalRequired = false
        KarhooConfig.disablePrebookRides = true
        KarhooConfig.excludedFilterCategories = [.fleetCapabilities]
        KarhooConfig.disableCallDriverOrFleetFeature = true
        tokenLoginAndShowComponents(token: Keys.braintreeAuthToken)
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
    
    private func tokenLoginAndShowComponents(token: String) {
        let authService = Karhoo.getAuthService()
        
        authService.login(token: token).execute { result in
            print("token login: \(result)")
            if result.isSuccess() {
                self.showKarhooComponents()
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
    
    // MARK: - Booking flow as components, not drop-in
    var componentsNavigation: UINavigationController? = nil
    var ridePlanningVC: BookingMapScreen!
    var allocationView: TripAllocationView!
    var trackDriver: UIViewController!
    private func showKarhooComponents() {
        let journeyInfo: JourneyInfo? = nil
        
//        let originLat = CLLocationDegrees(Double(51.500869))
//        let originLon = CLLocationDegrees(Double(-0.124979))
//        let destLat = CLLocationDegrees(Double(51.502159))
//        let destLon = CLLocationDegrees(Double(-0.142040))
//
//        journeyInfo = JourneyInfo(
//            origin: CLLocation(latitude: originLat, longitude: originLon),
//            destination: CLLocation(latitude: destLat, longitude: destLon)
//        )
        
        ridePlanningVC = KarhooComponents.shared.bookingMapView(
            journeyInfo: journeyInfo
        ) { [weak self] screenResult in
                switch screenResult {
                case .completed(let result):
                    if let details = result.journeyDetails {
                        self?.ridePlanningSelected(journeyDetails: details)
                    }
                default:
                    break
                }
        } as? BookingMapScreen
        
        componentsNavigation = NavigationController(rootViewController: ridePlanningVC!, style: .primary)
        componentsNavigation!.modalPresentationStyle = .fullScreen
        self.present(componentsNavigation!, animated: true, completion: nil)
    }
    
    private func ridePlanningSelected(journeyDetails: KarhooUISDK.JourneyDetails) {
        let quoteList = KarhooComponents.shared.quoteList(
            navigationController: componentsNavigation!,
            journeyDetails: journeyDetails
        ) { [weak self] quote, journeyDetails in
                self?.quoteSelected(journeyDetails: journeyDetails, quote: quote)
            }
        
        componentsNavigation?.pushViewController(quoteList.baseViewController, animated: true)
    }
    
    private func quoteSelected(journeyDetails: KarhooUISDK.JourneyDetails, quote: Quote) {
        let checkout = KarhooComponents.shared.checkout(
            navigationController: componentsNavigation!,
            quote: quote,
            journeyDetails: journeyDetails,
            bookingMetadata: nil
        ) { [weak self] screenResult in
                switch screenResult {
                case .completed(let result):
                    if KarhooJourneyDetailsManager.shared.getJourneyDetails()?.isScheduled ?? false {
                        KarhooJourneyDetailsManager.shared.reset()
                        self?.componentsNavigation?.popToRootViewController(animated: true)
                    } else {
                        self?.allocation(trip: result.tripInfo)
                    }
                default:
                    break
                }
            }
        
        componentsNavigation?.pushViewController(checkout.baseViewController, animated: true)
    }
    
    private func allocation(trip: TripInfo) {
        // Init and pin the view to another view controller
        allocationView = KarhooComponents.shared.allocationView(delegate: self)
        ridePlanningVC.view.addSubview(allocationView!)
        allocationView.anchorToSuperview()
        
        // If the chosen view controller is the BookingMapScreen, use this method to hide the address bar, reset the map, 
        // and hide the bottom view with the NOW / LATER buttons.
        // It's not mandatory, but it makes the UI look cleaner
        ridePlanningVC.prepareForAllocation(with: trip)
        
        // Set the alpha of the view to 1, animate the spinner, and start observing the trip status to know when it was allocated
        allocationView.presentScreen(forTrip: trip)
    }
    
    private func tripBooked(tripInfo: TripInfo) {
        trackDriver = KarhooComponents.shared.followDriver(
            tripInfo: tripInfo
        ) { [weak self] screenResult in
            KarhooJourneyDetailsManager.shared.reset()
            
                switch screenResult {
                case .completed(let result):
                    switch result {
                    case .rebookTrip(_ ): // param type: JourneyDetails
                        print("Rebook trip")
                        self?.closeFollowDriver()
                    case .closed:
                        self?.closeFollowDriver()
                    }
                default:
                    break
                }
            }
        
        componentsNavigation?.present(trackDriver, animated: true)
    }
    
    private func closeFollowDriver() {
        trackDriver.dismiss(animated: true)
        componentsNavigation?.popToRootViewController(animated: true)
    }
}

extension ViewController: TripAllocationActions {
    func cancelTripFailed(error: KarhooSDK.KarhooError?, trip: KarhooSDK.TripInfo) {
        resetPostAllocation()
        componentsNavigation?.popToRootViewController(animated: true)
    }
    
    func tripAllocated(trip: KarhooSDK.TripInfo) {
        resetPostAllocation()
        tripBooked(tripInfo: trip)
    }
    
    func tripCancelledBySystem(trip: KarhooSDK.TripInfo) {
        resetPostAllocation()
        componentsNavigation?.popToRootViewController(animated: true)
    }
    
    func tripDriverAllocationDelayed(trip: KarhooSDK.TripInfo) {
        resetPostAllocation()
        // A delay in allocation does not mean it's cancelled. Show an alert to warn the user of the delay, or simply do nothing and wait for tripAllocated(:) to be triggered.
        tripBooked(tripInfo: trip)
    }
    
    func userSuccessfullyCancelledTrip() {
        resetPostAllocation()
        componentsNavigation?.popToRootViewController(animated: true)
    }
    
    private func resetPostAllocation() {
        // Set the view alpha to 0, stop monitoring the trip status
        allocationView.dismissScreen()
        // Show the address bar and whatever other necessary UI to start the booking process again
        ridePlanningVC.resetPrepareForAllocation()
    }
}
