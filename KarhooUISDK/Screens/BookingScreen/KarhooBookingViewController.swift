//
//  BookingViewController.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooSDK
import CoreLocation
import SwiftUI

final class KarhooBookingViewController: UIViewController, BookingView {
    
    private var navigationBar: KarhooNavigationBarView!
    private var addressBar: AddressBarView!
    private var tripAllocationView: KarhooTripAllocationView!
    private var bottomNotificationView: KarhooNotificationView!
    private var bottomNotificationViewBottomConstraint: NSLayoutConstraint!
    private var mapView: MapView = KarhooMKMapView()
    private var sideMenu: SideMenu?
    private var journeyInfo: JourneyInfo?
    private let presenter: BookingPresenter
    private let mapPresenter: BookingMapPresenter
    private let feedbackMailComposer: FeedbackEmailComposer
    private let analyticsProvider: Analytics

    init(presenter: BookingPresenter,
         mapPresenter: BookingMapPresenter = KarhooBookingMapPresenter(),
         feedbackMailComposer: FeedbackEmailComposer = KarhooFeedbackEmailComposer(),
         analyticsProvider: Analytics = KarhooUISDKConfigurationProvider.configuration.analytics(),
         journeyInfo: JourneyInfo? = nil) {
        self.presenter = presenter
        self.mapPresenter = mapPresenter
        self.feedbackMailComposer = feedbackMailComposer
        self.analyticsProvider = analyticsProvider
        self.journeyInfo = journeyInfo
        super.init(nibName: nil, bundle: nil)
        self.feedbackMailComposer.set(parent: self)
        
        self.setUpView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        forceLightMode()
        setupMapView(reverseGeolocate: journeyInfo == nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
        sideMenu?.hideMenu()
        setupNavigationBar()
        mapView.set(userMarkerVisible: true)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        let masterViewModel = KarhooBottomSheetViewModel(
//            title: UITexts.Booking.prebookConfirmed
//        ) {
//            self.dismiss(animated: true, completion: nil)
//        }
//        
//        let contentViewModel = KarhooBookingConfirmationViewModel(
//            journeyDetails: JourneyDetails(),
//            quote: getRandomQuote(),
//            shouldShowLoyalty: true
//        ) {
//            //self?.prebookConfirmationCompleted(result: result, trip: trip)
//            print("Show details")
//        }
//         
//         let screenBuilder = UISDKScreenRouting.default.bottomSheetScreen()
//         let sheet = screenBuilder.buildBottomSheetScreenBuilderForUIKit(viewModel: masterViewModel) {
//             KarhooBookingConfirmationView(viewModel: contentViewModel)
//         }
//        
//        present(sheet, animated: true)
//    }
//    
//    func getRandomQuote(quoteId: String = "1234",
//                              availabilityId: String = "12345",
//                              fleetName: String = "My Fleet",
//                              highPrice: Int = 1000,
//                              lowPrice: Int = 100,
//                              qtaHighMinutes: Int = 10,
//                              qtaLowMinutes: Int = 1,
//                              quoteType: QuoteType = .fixed,
//                              categoryName: String = "Standard",
//                              currencyCode: String = "GBP",
//                              source: QuoteSource = .market,
//                              pickUpType: PickUpType = .default,
//                              passengerCapacity: Int = 1,
//                              luggageCapacity: Int = 2,
//                              type: String = "Standard",
//                              serviceLevelAgreements: ServiceAgreements? = ServiceAgreements()) -> Quote {
//        let price = QuotePrice(highPrice: Double(highPrice),
//                               lowPrice: Double(lowPrice),
//                               currencyCode: currencyCode,
//                               intLowPrice: lowPrice,
//                               intHighPrice: highPrice)
//        let qta = QuoteQta(highMinutes: qtaHighMinutes, lowMinutes: qtaLowMinutes)
//        let fleet = Fleet(name: fleetName)
//        let vehicle = QuoteVehicle(vehicleClass: categoryName, type: type, qta: qta, passengerCapacity: passengerCapacity, luggageCapacity: luggageCapacity)
//        return Quote(id: quoteId,
//                     quoteType: quoteType,
//                     source: source,
//                     pickUpType: pickUpType,
//                     fleet: fleet,
//                     vehicle: vehicle,
//                     price: price,
//                     validity: 1,
//                     serviceLevelAgreements: serviceLevelAgreements ?? ServiceAgreements())
//    }

    private func setUpView() {
        presenter.load(view: self)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(mapView)

        NSLayoutConstraint.activate([
            mapView.widthAnchor.constraint(equalTo: view.widthAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor),
            mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        navigationBar = KarhooNavigationBarView()
        navigationBar.set(rightItemHidden: Karhoo.configuration.authenticationMethod().guestSettings != nil)
        navigationBar.set(actions: self)
        view.addSubview(navigationBar)
        
        _ = [navigationBar.topAnchor.constraint(equalTo: view.topAnchor),
             navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)].map { $0.isActive = true }

        addressBar = KarhooUI.components.addressBar(journeyInfo: journeyInfo)

        view.insertSubview(addressBar, aboveSubview: mapView)

        _ = [addressBar.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
             addressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.0),
             addressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                  constant: -10.0)].map { $0.isActive = true }
        
        tripAllocationView = KarhooTripAllocationView()
        tripAllocationView.set(actions: self)
        view.addSubview(tripAllocationView)
        _ = [tripAllocationView.topAnchor.constraint(equalTo: view.topAnchor),
             tripAllocationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             tripAllocationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             tripAllocationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)].map { $0.isActive = true }
        
        bottomNotificationView = KarhooNotificationView(hasBottomInset: true)
        setupBottomNotification()
        view.addSubview(bottomNotificationView)
        
        _ = [bottomNotificationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             bottomNotificationView.trailingAnchor.constraint(equalTo: view.trailingAnchor)].map { $0.isActive = true }
        bottomNotificationViewBottomConstraint = bottomNotificationView.bottomAnchor.constraint(
            equalTo: view.bottomAnchor, constant: 150.0)
        bottomNotificationViewBottomConstraint.isActive = true
    }
    
    private func setupMapView(reverseGeolocate: Bool) {
        mapPresenter.load(
            map: mapView,
            reverseGeolocate: reverseGeolocate,
            onLocationPermissionDenied: { [weak self] in
                // Do not show pop up when allocation view is visible
                guard self?.tripAllocationView.alpha != 1 else {
                    return
                }
                self?.showNoLocationPermissionsPopUp()
            }
        )
        mapView.set(presenter: mapPresenter)
    }
    
    private func setupBottomNotification() {
        let header = UITexts.Booking.noAvailabilityHeader
        let text = UITexts.Booking.noAvailabilityBody
        let linkText = UITexts.Booking.noAvailabilityLink
        let body = String(format: text, linkText)

        let string = NSMutableAttributedString(string: "\(header)\n\(body)")
        string.font(KarhooUI.fonts.headerBold(), forStrings: header)
        string.font(KarhooUI.fonts.bodyRegular(), forStrings: body)
        string.textColor(KarhooUI.colors.neonRed, forStrings: linkText)
        string.font(KarhooUI.fonts.bodyBold(), forStrings: linkText)
        bottomNotificationView?.change(title: string)

        bottomNotificationView?.addLink(linkText) { [weak self] in
            _ = self?.feedbackMailComposer.showNoCoverageEmail()
        }
    }

    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationItem.backButtonTitle = ""
    }

    func reset() {
        presenter.resetJourneyDetails()
    }

    func resetAndLocate() {
        presenter.resetJourneyDetails()
        mapPresenter.focusMap()
    }

    func set(journeyDetails: JourneyDetails) {
        DispatchQueue.main.async { [weak self] in
            self?.presenter.populate(with: journeyDetails)
        }
    }

    func showAllocationScreen(trip: TripInfo) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn,
                       animations: { [weak self] in
                        self?.addressBar.alpha = 0
                        self?.navigationBar.alpha = 0
						self?.mapView.set(focusButtonHidden: true)
            }, completion: nil)

        tripAllocationView?.presentScreen(forTrip: trip)

        let location = trip.origin.position.toCLLocation()
        mapView.center(on: location, zoomLevel: mapView.idealMaximumZoom)
        mapView.removeTripLine()
    }

    func hideAllocationScreen() {
        addressBar.alpha = 1
        navigationBar.alpha = 1
        tripAllocationView.dismissScreen()
    }

    func set(sideMenu: SideMenu) {
        self.sideMenu = sideMenu
    }

    func set(leftNavigationButton: NavigationBarItemIcon) {
        navigationBar.set(leftIcon: leftNavigationButton)
    }
    
    private func showNoLocationPermissionsPopUp() {
        let alertController = UIAlertController(
            title: UITexts.Booking.noLocationPermissionTitle,
            message: UITexts.Booking.noLocationPermissionMessage,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(
            title: UITexts.Booking.noLocationPermissionConfirm,
            style: .default,
            handler: { _ in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
        ))
        alertController.addAction(UIAlertAction(title: UITexts.Generic.cancel, style: .cancel))
        showAsOverlay(item: alertController, animated: true)
    }
}

extension KarhooBookingViewController: TripAllocationActions {

    func userSuccessfullyCancelledTrip() {
        presenter.tripSuccessfullyCancelled()
        setupMapView(reverseGeolocate: true)
    }

    func tripAllocated(trip: TripInfo) {
        presenter.tripAllocated(trip: trip)
        setupMapView(reverseGeolocate: true)
    }

    func tripCancelledBySystem(trip: TripInfo) {
        presenter.tripCancelledBySystem(trip: trip)
        setupMapView(reverseGeolocate: true)
    }
    
    func tripDriverAllocationDelayed(trip: TripInfo) {
        presenter.tripDriverAllocationDelayed(trip: trip)
        setupMapView(reverseGeolocate: true)
    }
    
    func cancelTripFailed(error: KarhooError?,
                          trip: TripInfo) {
        presenter.tripCancellationFailed(trip: trip)
        setupMapView(reverseGeolocate: true)
    }
}

extension KarhooBookingViewController: NavigationBarActions {

    func rightButtonPressed() {
        openRidesList(presentationStyle: nil)
    }

    func leftButtonPressed() {
        if let menu = sideMenu {
            menu.showMenu()
        } else {
            presenter.exitPressed()
        }
    }
}

extension KarhooBookingViewController: BookingScreen {

    func openRidesList(presentationStyle: UIModalPresentationStyle?) {
        presenter.showRidesList(presentationStyle: presentationStyle)
    }

    func openTrip(_ trip: TripInfo) {
        presenter.goToTripView(trip: trip)
    }
    
    func openRideDetailsFor(_ trip: TripInfo) {
        presenter.showRideDetailsView(trip: trip)
    }
}

// MARK: Builder
public final class KarhooBookingScreenBuilder: BookingScreenBuilder {

    private let locationService: LocationService

    public init(locationService: LocationService = KarhooLocationService()) {
        self.locationService = locationService
    }
    
    public func buildBookingScreen(journeyInfo: JourneyInfo? = nil,
                                   passengerDetails: PassengerDetails? = nil,
                                   callback: ScreenResultCallback<BookingScreenResult>?) -> Screen {
        PassengerInfo.shared.set(details: passengerDetails)

        var validatedJourneyInfo: JourneyInfo?

        if let date = journeyInfo?.date {
            validatedJourneyInfo =  Date(timeIntervalSinceNow: 0).compare(date) ==
                .orderedDescending ? nil : journeyInfo
        } else {
            validatedJourneyInfo = journeyInfo
        }

        let router = KarhooBookingRouter()
        let bookingPresenter = KarhooBookingPresenter(router: router, callback: callback)
        let bookingViewController = KarhooBookingViewController(presenter: bookingPresenter, journeyInfo: validatedJourneyInfo)
        router.viewController = bookingViewController
        router.checkoutScreenBuilder = UISDKScreenRouting.default.checkout()

        if let sideMenuRouting = KarhooUI.sideMenuHandler {
            let sideMenu = UISDKScreenRouting
                .default.sideMenu().buildSideMenu(hostViewController: bookingViewController,
                                                  routing: sideMenuRouting)

            bookingViewController.set(sideMenu: sideMenu)
            bookingViewController.set(leftNavigationButton: .menuIcon)

            let navigationController = NavigationController(rootViewController: bookingViewController, style: .primary)
            navigationController.viewControllers.insert(sideMenu.getFlowItem(),
                    at: navigationController.viewControllers.endIndex)
            navigationController.modalPresentationStyle = .fullScreen
            return navigationController
        } else {
            let navigationController = NavigationController(rootViewController: bookingViewController, style: .primary)
            navigationController.modalPresentationStyle = .fullScreen
            bookingViewController.set(leftNavigationButton: .exitIcon)
            return navigationController
        }
    }
}
