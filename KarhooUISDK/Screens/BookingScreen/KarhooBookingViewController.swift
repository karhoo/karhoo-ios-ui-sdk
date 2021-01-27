//
//  BookingViewController.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooSDK
import FloatingPanel
import CoreLocation

final class KarhooBookingViewController: UIViewController, BookingView {
    
    private var navigationBar: KarhooNavigationBarView!
    private var addressBar: AddressBarView!
    private var tripAllocationView: KarhooTripAllocationView!
    private var bottomNotificationView: KarhooNotificationView!
    private var bottomNotificationViewBottomConstraint: NSLayoutConstraint!
    private var quoteListView = KarhooUI.components.quoteList()
    private var quoteListPanelVC: FloatingPanelController?
    private var mapView: MapView = KarhooMKMapView()
    private var sideMenu: SideMenu?
    private let grabberTopPadding: CGFloat = 6.0
    private var journeyInfo: JourneyInfo?
    private let presenter: BookingPresenter
    private let addressBarPresenter: AddressBarPresenter
    private let mapPresenter: BookingMapPresenter
    private let feedbackMailComposer: FeedbackEmailComposer
    private let analyticsProvider: Analytics

    init(presenter: BookingPresenter,
         addressBarPresenter: AddressBarPresenter = BookingAddressBarPresenter(),
         mapPresenter: BookingMapPresenter = KarhooBookingMapPresenter(),
         feedbackMailComposer: FeedbackEmailComposer = KarhooFeedbackEmailComposer(),
         analyticsProvider: Analytics = KarhooAnalytics(),
         journeyInfo: JourneyInfo? = nil) {
        self.presenter = presenter
        self.addressBarPresenter = addressBarPresenter
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

        quoteListView.set(quoteListActions: self)
    
        setupQuoteListPanel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let injectedTrip = journeyInfo {
            addressBarPresenter.setJourneyInfo(injectedTrip)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapPresenter.load(map: mapView, reverseGeolocate: journeyInfo != nil)
        mapView.set(presenter: mapPresenter)
    }

    private func setupQuoteListPanel() {
        let mainPanelVC = FloatingPanelController()
        
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 8.0
        appearance.backgroundColor = .clear
        
        let shadow = SurfaceAppearance.Shadow()
        shadow.color = .black
        shadow.offset = CGSize(width: 0, height: 16)
        shadow.radius = 16
        shadow.spread = 8
        appearance.shadows = [shadow]
        
        mainPanelVC.delegate = self
        mainPanelVC.isRemovalInteractionEnabled = false
        mainPanelVC.surfaceView.appearance = appearance
        mainPanelVC.surfaceView.backgroundColor = .clear

        mainPanelVC.set(contentViewController: quoteListView)
        mainPanelVC.track(scrollView: quoteListView.tableView)
        setupGrabberHandle(forVC: mainPanelVC)
        quoteListPanelVC = mainPanelVC
    }

    private func setupGrabberHandle(forVC mainPanelVC: FloatingPanelController) {
        let grabberHandleView = KarhooGrabberHandleView()
        mainPanelVC.surfaceView.grabberHandle.isHidden = true
        mainPanelVC.surfaceView.addSubview(grabberHandleView)
        grabberHandleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            grabberHandleView.topAnchor
                .constraint(equalTo: mainPanelVC.surfaceView.topAnchor, constant: grabberTopPadding),
            grabberHandleView.widthAnchor
                .constraint(equalToConstant: grabberHandleView.frame.width),
            grabberHandleView.heightAnchor
                .constraint(equalToConstant: grabberHandleView.frame.height),
            grabberHandleView.centerXAnchor
                .constraint(equalTo: mainPanelVC.surfaceView.centerXAnchor)
            ])

        let action = #selector(floatingViewGrabberHandleTapped(_:))
        let tap = UITapGestureRecognizer(target: self, action: action)
        grabberHandleView.addGestureRecognizer(tap)
    }

    @objc
    func floatingViewGrabberHandleTapped(_ sender: UITapGestureRecognizer) {
        let moveTo: FloatingPanelState = quoteListPanelVC?.state == .full ?  .half : .full
        self.quoteListPanelVC?.move(to: moveTo, animated: true)
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.viewWillAppear()
        sideMenu?.hideMenu()
        mapView.set(userMarkerVisible: true)
    }

    func showQuoteList() {
        quoteListPanelVC?.addPanel(toParent: self, at: -1, animated: true)
        setMapPadding(bottomPaddingEnabled: true)
    }

    func hideQuoteList() {
        quoteListPanelVC?.removePanelFromParent(animated: true)
    }

    func reset() {
        presenter.resetBookingStatus()
    }

    func resetAndLocate() {
        presenter.resetBookingStatus()
        mapPresenter.focusMap()
    }

    func set(bookingDetails: BookingDetails) {
        DispatchQueue.main.async { [weak self] in
            self?.presenter.populate(with: bookingDetails)
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

    func setMapPadding(bottomPaddingEnabled: Bool) {
        let margin: CGFloat = 10
        let extraPadding: CGFloat = 10
        let addressBarBottom = (addressBar.frame.maxY) + extraPadding * 2
        let bottomContainerTop: CGFloat = bottomPaddingEnabled ? (QuoteListPanelLayout.compactSize + extraPadding) : 0
        
        let padding = UIEdgeInsets(top: addressBarBottom,
                                   left: margin,
                                   bottom: bottomContainerTop,
                                   right: margin)
        mapView.set(padding: padding)
    }

    func set(sideMenu: SideMenu) {
        self.sideMenu = sideMenu
    }

    func set(leftNavigationButton: NavigationBarItemIcon) {
        navigationBar.set(leftIcon: leftNavigationButton)
    }
}

extension KarhooBookingViewController: FloatingPanelControllerDelegate {

    func floatingPanel(_ vc: FloatingPanelController,
                       layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return QuoteListPanelLayout()
    }
}

extension KarhooBookingViewController: TripAllocationActions {

    func userSuccessfullyCancelledTrip() {
        presenter.tripSuccessfullyCancelled()
    }

    func tripAllocated(trip: TripInfo) {
        presenter.tripAllocated(trip: trip)
    }

    func tripCancelledBySystem(trip: TripInfo) {
        presenter.tripCancelledBySystem(trip: trip)
    }
    
    func tripDriverAllocationDelayed(trip: TripInfo) {
        presenter.tripDriverAllocationDelayed(trip: trip)
    }
    
    func cancelTripFailed(error: KarhooError?,
                          trip: TripInfo) {
        presenter.tripCancellationFailed(trip: trip)
    }
}

extension KarhooBookingViewController: QuoteCategoryBarActions {

    func didSelectCategory(_ category: QuoteCategory) {
        quoteListView.didSelectQuoteCategory(category)
    }
}

extension KarhooBookingViewController: QuoteListActions {

    func didSelectQuote(_ quote: Quote) {
        hideQuoteList()
        presenter.didSelectQuote(quote: quote)
    }

    func quotesAvailabilityDidUpdate(availability: Bool) {
        if availability == false {
            hideQuoteList()
        }

        showAvailabilityBar(!availability)
    }
    
    private func showAvailabilityBar(_ show: Bool) {
        bottomNotificationViewBottomConstraint.constant = show ? 0.0 : 150.0
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
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
        PassengerInfo.shared.passengerDetails = passengerDetails

        var validatedJourneyInfo: JourneyInfo?

        if let date = journeyInfo?.date {
            validatedJourneyInfo =  Date(timeIntervalSinceNow: 0).compare(date) ==
                .orderedDescending ? nil : journeyInfo
        } else {
            validatedJourneyInfo = journeyInfo
        }

        let bookingPresenter = KarhooBookingPresenter(callback: callback)
        let bookingViewController = KarhooBookingViewController(presenter: bookingPresenter,
                                                                journeyInfo: validatedJourneyInfo)

        if let sideMenuRouting = KarhooUI.sideMenuHandler {
            let sideMenu = UISDKScreenRouting
                .default.sideMenu().buildSideMenu(hostViewController: bookingViewController,
                                                  routing: sideMenuRouting)

            bookingViewController.set(sideMenu: sideMenu)
            bookingViewController.set(leftNavigationButton: .menuIcon)

            let navigationController = UINavigationController(rootViewController: bookingViewController)
            navigationController.viewControllers.insert(sideMenu.getFlowItem(),
                    at: navigationController.viewControllers.endIndex)
            navigationController.setNavigationBarHidden(true, animated: false)
            navigationController.modalPresentationStyle = .fullScreen
            return navigationController

        } else {
            bookingViewController.set(leftNavigationButton: .exitIcon)
            bookingViewController.modalPresentationStyle = .fullScreen
            return bookingViewController
        }
    }
}
