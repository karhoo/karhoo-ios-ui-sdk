//
//  KarhooBookingPresenter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import CoreLocation
import KarhooSDK
import UIKit
import Combine

final class KarhooBookingPresenter {

    private weak var view: BookingView?
    private let journeyDetailsManager: JourneyDetailsManager
    private let userService: UserService
    private let analytics: Analytics
    private let phoneNumberCaller: PhoneNumberCallerProtocol
    private let callback: ScreenResultCallback<BookingScreenResult>?
    private let tripScreenBuilder: TripScreenBuilder
    private let rideDetailsScreenBuilder: RideDetailsScreenBuilder
    private let addressScreenBuilder: AddressScreenBuilder
    private let datePickerScreenBuilder: DatePickerScreenBuilder
    private let ridesScreenBuilder: RidesScreenBuilder
    private let tripRatingCache: TripRatingCache
    private let urlOpener: URLOpener
    private let coverageCheckWorker: CoverageCheckWorker
    private let paymentService: PaymentService
    private let vehicleRulesProvider: VehicleRulesProvider
    private let router: BookingRouter

    private var coverageCache: [String: Bool] = [:]
    private var coverageCheckInProgress: [String] = []

    var hasCoverageInTheAreaPublisher = CurrentValueSubject<Bool?, Never>(nil)
    var isAsapEnabledPublisher = CurrentValueSubject<Bool, Never>(false)
    var isScheduleForLaterEnabledPublisher = CurrentValueSubject<Bool, Never>(false)
    
    // MARK: - Init
    init(router: BookingRouter,
         journeyDetailsManager: JourneyDetailsManager = KarhooJourneyDetailsManager.shared,
         userService: UserService = Karhoo.getUserService(),
         analytics: Analytics = KarhooUISDKConfigurationProvider.configuration.analytics(),
         phoneNumberCaller: PhoneNumberCallerProtocol = PhoneNumberCaller(),
         callback: ScreenResultCallback<BookingScreenResult>? = nil,
         tripScreenBuilder: TripScreenBuilder = UISDKScreenRouting.default.tripScreen(),
         rideDetailsScreenBuilder: RideDetailsScreenBuilder = UISDKScreenRouting.default.rideDetails(),
         ridesScreenBuilder: RidesScreenBuilder = UISDKScreenRouting.default.rides(),
         addressScreenBuilder: AddressScreenBuilder = UISDKScreenRouting.default.address(),
         datePickerScreenBuilder: DatePickerScreenBuilder = UISDKScreenRouting.default.datePicker(),
         tripRatingCache: TripRatingCache = KarhooTripRatingCache(),
         urlOpener: URLOpener = KarhooURLOpener(),
         coverageCheckWorker: CoverageCheckWorker = KarhooCoverageCheckWorker(),
         paymentService: PaymentService = Karhoo.getPaymentService(),
         vehicleRulesProvider: VehicleRulesProvider = KarhooVehicleRulesProvider()
    ) {
        self.router = router
        self.userService = userService
        self.analytics = analytics
        self.journeyDetailsManager = journeyDetailsManager
        self.phoneNumberCaller = phoneNumberCaller
        self.callback = callback
        self.tripScreenBuilder = tripScreenBuilder
        self.rideDetailsScreenBuilder = rideDetailsScreenBuilder
        self.addressScreenBuilder = addressScreenBuilder
        self.datePickerScreenBuilder = datePickerScreenBuilder
        self.ridesScreenBuilder = ridesScreenBuilder
        self.tripRatingCache = tripRatingCache
        self.urlOpener = urlOpener
        self.coverageCheckWorker = coverageCheckWorker
        self.paymentService = paymentService
        self.vehicleRulesProvider = vehicleRulesProvider
        userService.add(observer: self)
    }
    // swiftlint:enable line_length

    deinit {
        userService.remove(observer: self)
        journeyDetailsManager.remove(observer: self)
    }

    // MARK: - Coverage
    
    private func checkCoverage(
        using details: JourneyDetails? = KarhooJourneyDetailsManager.shared.getJourneyDetails()
    ) {
        coverageCheckWorker.getCoverage(
            for: details,
            completion: { [weak self] hasCoverage in
                self?.hasCoverageInTheAreaPublisher.send(hasCoverage)
                self?.updateAsapRideEnabled(using: details)
            }
        )
    }
    
    // MARK: - Checkout
    private func showCheckoutView(
        quote: Quote,
        journeyDetails: JourneyDetails,
        bookingMetadata: [String: Any]? = KarhooUISDKConfigurationProvider.configuration.bookingMetadata
    ) {
        router.routeToCheckout(
            quote: quote,
            journeyDetails: journeyDetails,
            bookingMetadata: bookingMetadata,
            bookingRequestCompletion: { [weak self] result, quote, journeyDetails in
                self?.bookingRequestCompleted(result: result, quote: quote, details: journeyDetails)
            }
        )
    }

    // MARK: - Trip booked
    private func bookingRequestCompleted(result: ScreenResult<KarhooCheckoutResult>, quote: Quote, details: JourneyDetails) {
        if let checkoutResult = result.completedValue() {
            handleNewlyBooked(result: checkoutResult,
                              quote: quote,
                              journeyDetails: details)
            return
        }

        if let error = result.errorValue() {
            view?.show(error: error)
        }
    }

    private func rebookTrip(_ trip: TripInfo) {
        var journeyDetails = JourneyDetails(originLocationDetails: trip.origin.toLocationInfo())
        journeyDetails.destinationLocationDetails = trip.destination?.toLocationInfo()

        populate(with: journeyDetails)
    }

    private func handleNewlyBooked(result: KarhooCheckoutResult,
                                   quote: Quote,
                                   journeyDetails: JourneyDetails) {
        let trip = result.tripInfo

        switch trip.state {
        case .noDriversAvailable:
            view?.reset()
            view?.showAlert(title: UITexts.Trip.noDriversAvailableTitle,
                            message: String(format: UITexts.Trip.noDriversAvailableMessage,
                                            trip.fleetInfo.name),
                            error: nil)

        case .karhooCancelled:
            view?.reset()
            view?.showAlert(title: UITexts.Trip.karhooCancelledAlertTitle,
                            message: UITexts.Trip.karhooCancelledAlertMessage,
                            error: nil)

        default:
            if journeyDetails.isScheduled {
                view?.reset()
                
                if result.showTripDetails {
                    finishWithResult(.completed(result: .prebookConfirmed(tripInfo: trip)))
                }
            } else {
                view?.showAllocationScreen(trip: trip)
            }
        }
    }
}

// MARK: - BookingDetailsObserver
extension KarhooBookingPresenter: JourneyDetailsObserver {
    func journeyDetailsChanged(details: JourneyDetails?) {
        guard let details = details,
            details.originLocationDetails != nil,
            details.destinationLocationDetails != nil
        else {
            isAsapEnabledPublisher.send(false)
            isScheduleForLaterEnabledPublisher.send(false)
            hasCoverageInTheAreaPublisher.send(nil)
            return
        }
        checkCoverage(using: details)
        updateAsapRideEnabled(using: details)
        updateScheduledRideEnabled(using: details)
    }
}

// MARK: - UserStateObserver
extension KarhooBookingPresenter: UserStateObserver {

    func userStateUpdated(user: UserInfo?) {
        if user == nil {
            resetJourneyDetails()
            tripRatingCache.clearTripRatings()
        }
    }
}

// MARK: - BookingPresenter
extension KarhooBookingPresenter: BookingPresenter {

    // MARK: Lifecycle
    func load(view: BookingView?) {
        self.view = view
        fetchPaymentProvider()
        fetchVehicleRules()
    }
    
    func viewWillAppear() {
        if isSdkVersionSupported() {
            analytics.bookingScreenOpened()
            journeyDetailsManager.remove(observer: self)
            journeyDetailsManager.add(observer: self)
            checkCoverage()
        } else {
            view?.showIncorrectVersionPopup(completion: { [weak self] in
                self?.exitPressed()
            })
        }
    }

    func viewDidDissapear() {
        journeyDetailsManager.remove(observer: self)
    }

    func exitPressed() {
        journeyDetailsManager.reset()
        view?.dismiss(animated: true, completion: { [weak self] in
            self?.callback?(ScreenResult.cancelled(byUser: true))
        })
    }

    func asapRidePressed() {
        journeyDetailsManager.set(prebookDate: nil)
        showQuoteList()
    }

    func dataForScheduledRideProvided() {
        showQuoteList()
    }

    // MARK: Utils

    private func updateAsapRideEnabled(
        using details: JourneyDetails? = KarhooJourneyDetailsManager.shared.getJourneyDetails()
    ) {
        guard let details else {
            isAsapEnabledPublisher.send(false)
            return
        }
        let canProceedWithAsapBooking = details.originLocationDetails != nil &&
        details.destinationLocationDetails != nil &&
        hasCoverageInTheAreaPublisher.value == true
        
        isAsapEnabledPublisher.send(canProceedWithAsapBooking)
    }
    
    private func isSdkVersionSupported() -> Bool {
        let featureFlagsProvider = KarhooFeatureFlagProvider()
        let flags = featureFlagsProvider.get()
        let adyenPaymentManagerName = "KarhooUISDK.AdyenPaymentManager"
        let paymentManagerName = String(describing: KarhooUISDKConfigurationProvider.configuration.paymentManager.self)
    
        return !(flags?.flags.adyenAvailable == false && paymentManagerName == adyenPaymentManagerName)
    }

    private func updateScheduledRideEnabled(using details: JourneyDetails) {
        let areAllDataProvided = details.originLocationDetails != nil && details.destinationLocationDetails != nil
        isScheduleForLaterEnabledPublisher.send(areAllDataProvided)
    }
    
    private func fetchPaymentProvider() {
        if !Karhoo.configuration.authenticationMethod().isGuest() {
            return
        }

        paymentService.getPaymentProvider().execute(callback: { _ in})
    }

    private func fetchVehicleRules() {
        vehicleRulesProvider.update()
    }

    func resetJourneyDetails() {
        journeyDetailsManager.reset()
    }

    func getJourneyDetails() -> JourneyDetails? {
        return journeyDetailsManager.getJourneyDetails()
    }

    func populate(with journeyDetails: JourneyDetails) {
        journeyDetailsManager.reset(with: journeyDetails)
    }

    // MARK: Trip cancellation
    func tripCancelledBySystem(trip: TripInfo) {
        resetJourneyDetails()

        switch trip.state {
        case .karhooCancelled:
            view?.showAlert(title: UITexts.Trip.karhooCancelledAlertTitle,
                            message: UITexts.Trip.karhooCancelledAlertMessage,
                            error: nil)
        default:
            view?.showAlert(title: UITexts.Trip.noDriversAvailableTitle,
                            message: String(format: UITexts.Trip.noDriversAvailableMessage, trip.fleetInfo.name),
                            error: nil)
        }

        view?.hideAllocationScreen()

        var journeyDetails = JourneyDetails(originLocationDetails: trip.origin.toLocationInfo())
        journeyDetails.destinationLocationDetails = trip.destination?.toLocationInfo()
        populate(with: journeyDetails)
    }

    func tripCancellationFailed(trip: TripInfo) {
        let callFleet = UITexts.Trip.tripCancelBookingFailedAlertCallFleetButton

        view?.showAlert(title: UITexts.Trip.tripCancelBookingFailedAlertTitle,
                        message: UITexts.Trip.tripCancelBookingFailedAlertMessage,
                        error: nil,
                        actions: [
                            AlertAction(title: UITexts.Generic.cancel, style: .default, handler: nil),
                            AlertAction(title: callFleet, style: .default, handler: { [weak self] _ in
                                self?.phoneNumberCaller.call(number: trip.fleetInfo.phoneNumber)
                            })
            ])
    }
    
    func tripSuccessfullyCancelled() {
        resetJourneyDetails()
        view?.hideAllocationScreen()
        view?.showAlert(title: UITexts.Bookings.cancellationSuccessAlertTitle,
                        message: UITexts.Bookings.cancellationSuccessAlertMessage,
                        error: nil)
    }
    
    // MARK: Trip allocation
    func tripDriverAllocationDelayed(trip: TripInfo) {
        view?.showAlert(title: UITexts.GenericTripStatus.driverAllocationDelayTitle,
                        message: UITexts.GenericTripStatus.driverAllocationDelayMessage,
                        error: nil,
                        actions: [
                            AlertAction(title: UITexts.Generic.ok, style: .default, handler: { [weak self] _ in
                                self?.tripWaitOnRideDetails(trip: trip)
                            })
                        ])
    }
    
    func tripAllocated(trip: TripInfo) {
        view?.reset()
        view?.hideAllocationScreen()
        finishWithResult(.completed(result: .tripAllocated(tripInfo: trip)))
    }
    
    func goToTripView(trip: TripInfo) {
        if Karhoo.configuration.authenticationMethod().isGuest() {
            let dismissTrackingAction = AlertAction(title: UITexts.Trip.trackTripAlertDismissAction, style: .cancel)
            let trackTripAction = AlertAction(title: UITexts.Trip.trackTripAlertAction, style: .default) { _ in
                self.urlOpener.openAgentPortalTracker(followCode: trip.followCode)
            }
            view?.showAlert(title: UITexts.Trip.trackTripAlertTitle,
                            message: UITexts.Trip.trackTripAlertMessage,
                            error: .none,
                            actions: [dismissTrackingAction, trackTripAction])
        } else {
            let tripView = tripScreenBuilder.buildTripScreen(trip: trip,
                                                                callback: tripViewCallback)
            view?.present(tripView, animated: true, completion: nil)
        }
    }

    // MARK: QuoteList

    private func showQuoteList() {
        guard let details = journeyDetailsManager.getJourneyDetails() else { return }
        router.routeToQuoteList(details: details) { [weak self] quote, journeyDetails in
            self?.showCheckoutView(
                quote: quote,
                journeyDetails: journeyDetails
            )
        }
    }

    // MARK: Prebook

    func finishWithResult(_ result: ScreenResult<BookingScreenResult>) {
        guard let callback = self.callback else {
            switch result.completedValue() {
            case .tripAllocated(let trip)?:
                goToTripView(trip: trip)
            case .prebookConfirmed(let trip):
                showRideDetailsView(trip: trip)
            default:
                break
            }
            return
        }

        callback(result)
    }

    // MARK: Ride details
    func tripWaitOnRideDetails(trip: TripInfo) {
        view?.resetAndLocate()
        view?.hideAllocationScreen()
        showRideDetailsView(trip: trip)
    }
    
    func showRidesList(presentationStyle: UIModalPresentationStyle?) {
        let ridesList = ridesScreenBuilder.buildRidesScreen(completion: { [weak self] result in
            self?.view?.dismiss(animated: true, completion: {
                ridesListCompleted(result: result)
            })
        })
        
        if let presStyle = presentationStyle {
            ridesList.modalPresentationStyle = presStyle
        }
    
        self.view?.present(ridesList, animated: true, completion: nil)

        func ridesListCompleted(result: ScreenResult<RidesListAction>) {
            guard let action = result.completedValue() else {
                return
            }

            switch action {
            case .trackTrip(let trip):
                goToTripView(trip: trip)
            case .bookNewTrip:
                view?.resetAndLocate()
            case .rebookTrip(let trip):
                rebookTrip(trip)
            }
        }
    }
    
    func showRideDetailsView(trip: TripInfo) {
        let rideDetailsViewController = rideDetailsScreenBuilder
            .buildOverlayRideDetailsScreen(trip: trip,
                                           callback: { [weak self] result in
                                            self?.view?.dismiss(animated: true, completion: { [weak self] in
                                                self?.rideDetailsScreenCompleted(result: result)
                                            })
            })

        view?.present(rideDetailsViewController, animated: true, completion: nil)
    }

    func rideDetailsScreenCompleted(result: ScreenResult<RideDetailsAction>) {
        guard let action = result.completedValue() else {
            return
        }

        switch action {
        case .trackTrip(let trip):
            goToTripView(trip: trip)
        case .rebookTrip(let trip):
            rebookTrip(trip)
        }
    }

    func tripViewCallback(result: ScreenResult<TripScreenResult>) {
        view?.dismiss(animated: true, completion: nil)
        switch result.completedValue() {
        case .some(.rebookTrip(let details)):
            populate(with: details)
        default: break
        }
    }
}
