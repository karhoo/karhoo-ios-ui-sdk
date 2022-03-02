//
//  KarhooBookingPresenter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import CoreLocation
import KarhooSDK

final class KarhooBookingPresenter {

    private weak var view: BookingView?
    private let journeyDetailsManager: JourneyDetailsManager
    private let userService: UserService
    private let analytics: Analytics
    private let phoneNumberCaller: PhoneNumberCallerProtocol
    private let callback: ScreenResultCallback<BookingScreenResult>?
    private let tripScreenBuilder: TripScreenBuilder
    private let rideDetailsScreenBuilder: RideDetailsScreenBuilder
    private let checkoutScreenBuilder: CheckoutScreenBuilder
    private let prebookConfirmationScreenBuilder: PrebookConfirmationScreenBuilder
    private let addressScreenBuilder: AddressScreenBuilder
    private let datePickerScreenBuilder: DatePickerScreenBuilder
    private let ridesScreenBuilder: RidesScreenBuilder
    private let tripRatingCache: TripRatingCache
    private let urlOpener: URLOpener
    private let paymentService: PaymentService

    // MARK: - Init
    init(journeyDetailsManager: JourneyDetailsManager = KarhooJourneyDetailsManager.shared,
         userService: UserService = Karhoo.getUserService(),
         analytics: Analytics = KarhooUISDKConfigurationProvider.configuration.analytics(),
         phoneNumberCaller: PhoneNumberCallerProtocol = PhoneNumberCaller(),
         callback: ScreenResultCallback<BookingScreenResult>? = nil,
         tripScreenBuilder: TripScreenBuilder = UISDKScreenRouting.default.tripScreen(),
         rideDetailsScreenBuilder: RideDetailsScreenBuilder = UISDKScreenRouting.default.rideDetails(),
         ridesScreenBuilder: RidesScreenBuilder = UISDKScreenRouting.default.rides(),
         checkoutScreenBuilder: CheckoutScreenBuilder = UISDKScreenRouting.default.checkout(),
         prebookConfirmationScreenBuilder: PrebookConfirmationScreenBuilder = UISDKScreenRouting.default.prebookConfirmation(),
         addressScreenBuilder: AddressScreenBuilder = UISDKScreenRouting.default.address(),
         datePickerScreenBuilder: DatePickerScreenBuilder = UISDKScreenRouting.default.datePicker(),
         tripRatingCache: TripRatingCache = KarhooTripRatingCache(),
         urlOpener: URLOpener = KarhooURLOpener(),
         paymentService: PaymentService = Karhoo.getPaymentService()) {
        self.userService = userService
        self.analytics = analytics
        self.journeyDetailsManager = journeyDetailsManager
        self.phoneNumberCaller = phoneNumberCaller
        self.callback = callback
        self.tripScreenBuilder = tripScreenBuilder
        self.rideDetailsScreenBuilder = rideDetailsScreenBuilder
        self.checkoutScreenBuilder = checkoutScreenBuilder
        self.prebookConfirmationScreenBuilder = prebookConfirmationScreenBuilder
        self.addressScreenBuilder = addressScreenBuilder
        self.datePickerScreenBuilder = datePickerScreenBuilder
        self.ridesScreenBuilder = ridesScreenBuilder
        self.tripRatingCache = tripRatingCache
        self.urlOpener = urlOpener
        self.paymentService = paymentService
        userService.add(observer: self)
        journeyDetailsManager.add(observer: self)
    }
    // swiftlint:enable line_length

    deinit {
        userService.remove(observer: self)
        journeyDetailsManager.remove(observer: self)
    }

    // MARK: - Checkout
    private func showCheckoutView(
        quote: Quote,
        journeyDetails: JourneyDetails,
        bookingMetadata: [String: Any]? = KarhooUISDKConfigurationProvider.configuration.bookingMetadata
    ) {
        let checkoutView = checkoutScreenBuilder
            .buildCheckoutScreen(
                quote: quote,
                journeyDetails: journeyDetails,
                bookingMetadata: bookingMetadata,
                callback: { [weak self] result in
                    self?.view?.dismiss(animated: false, completion: {
                        self?.bookingRequestCompleted(
                            result: result,
                            quote: quote,
                            details: journeyDetails
                        )
                    })
                }
            )

        view?.showAsOverlay(item: checkoutView, animated: false)
    }

    // MARK: - Trip booked
    private func bookingRequestCompleted(result: ScreenResult<TripInfo>, quote: Quote, details: JourneyDetails) {
        if let trip = result.completedValue() {
            handleNewlyBooked(trip: trip,
                              quote: quote,
                              journeyDetails: details)
            return
        }

        if let error = result.errorValue() {
            view?.show(error: error)
        }

        view?.showQuoteList()
    }

    private func rebookTrip(_ trip: TripInfo) {
        var journeyDetails = JourneyDetails(originLocationDetails: trip.origin.toLocationInfo())
        journeyDetails.destinationLocationDetails = trip.destination?.toLocationInfo()

        populate(with: journeyDetails)
        setViewMapPadding()
    }

    private func handleNewlyBooked(trip: TripInfo,
                                   quote: Quote,
                                   journeyDetails: JourneyDetails) {
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
                showPrebookConfirmation(quote: quote,
                                        trip: trip,
                                        journeyDetails: journeyDetails)
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
        else { return }
            didProvideJourneyDetails(details)
//            view?.showQuoteList()
//        } else {
//            view?.hideQuoteList()
//            view?.setMapPadding(bottomPaddingEnabled: false)
//        }

//        view?.quotesAvailabilityDidUpdate(availability: true)
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
    }
    
    func viewWillAppear() {
        setViewMapPadding()
        analytics.bookingScreenOpened()
    }

    func exitPressed() {
        journeyDetailsManager.reset()
        view?.dismiss(animated: true, completion: { [weak self] in
            self?.callback?(ScreenResult.cancelled(byUser: true))
        })
    }

    // MARK: Utils
    private func fetchPaymentProvider() {
        if !Karhoo.configuration.authenticationMethod().isGuest() {
            return
        }

        paymentService.getPaymentProvider().execute(callback: { _ in})
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
    
    func setViewMapPadding() {
        let journeyDetails = journeyDetailsManager.getJourneyDetails()
        if journeyDetails?.originLocationDetails != nil,
            journeyDetails?.destinationLocationDetails != nil {
            view?.setMapPadding(bottomPaddingEnabled: true)
        } else {
            view?.setMapPadding(bottomPaddingEnabled: false)
        }
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
    
    // MARK: Quotes
    func didSelectQuote(quote: Quote) {
        view?.hideQuoteList()

        guard let bookingDetails = getJourneyDetails() else {
            return
        }

        showCheckoutView(quote: quote, journeyDetails: bookingDetails)
    }

    // MARK: Prebook
    func showPrebookConfirmation(quote: Quote, trip: TripInfo, journeyDetails: JourneyDetails) {
        let prebookConfirmation = prebookConfirmationScreenBuilder
            .buildPrebookConfirmationScreen(quote: quote,
                                            journeyDetails: journeyDetails,
                                            confirmationCallback: { [weak self] result in
                                                self?.view?.dismiss(animated: true, completion: nil)
                                                self?.prebookConfirmationCompleted(result: result, trip: trip)
            })

        prebookConfirmation.modalTransitionStyle = .crossDissolve
        view?.showAsOverlay(item: prebookConfirmation, animated: true)
    }

    func prebookConfirmationCompleted(result: ScreenResult<PrebookConfirmationAction>, trip: TripInfo) {
        guard let action = result.completedValue() else {
            return
        }

        finishWithResult(.completed(result: .prebookConfirmed(tripInfo: trip, prebookConfirmationAction: action)))
    }

    func finishWithResult(_ result: ScreenResult<BookingScreenResult>) {
        guard let callback = self.callback else {
            switch result.completedValue() {
            case .tripAllocated(let trip)?:
                goToTripView(trip: trip)
            case .prebookConfirmed(let trip, let action)?:
                if case .rideDetails = action {
                    showRideDetailsView(trip: trip)
                }
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
    
    func didProvideJourneyDetails(_ details: JourneyDetails) {
        //TODO: Create router for this
        let qouteList = QuoteList.build(journeyDetails: details)
        view?.present(qouteList, animated: true)
    }
}
