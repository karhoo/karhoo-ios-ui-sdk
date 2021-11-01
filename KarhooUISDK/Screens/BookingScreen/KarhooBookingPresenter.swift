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
    private let bookingStatus: BookingStatus
    private let userService: UserService
    private let analyticsProvider: Analytics
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

    init(bookingStatus: BookingStatus = KarhooBookingStatus.shared,
         userService: UserService = Karhoo.getUserService(),
         analyticsProvider: Analytics = KarhooAnalytics(),
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
        self.analyticsProvider = analyticsProvider
        self.bookingStatus = bookingStatus
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
        bookingStatus.add(observer: self)
    }
    // swiftlint:enable line_length

    deinit {
        userService.remove(observer: self)
        bookingStatus.remove(observer: self)
    }

    private func showCheckoutView(quote: Quote,
                                  bookingDetails: BookingDetails,
                                  bookingMetadata: [String: Any]? = KarhooUISDKConfigurationProvider.configuration.bookingMetadata) {
        let checkoutView = checkoutScreenBuilder
            .buildCheckoutScreen(quote: quote,
                                 bookingDetails: bookingDetails,
                                 bookingMetadata: bookingMetadata,
                                 callback: { [weak self] result in
                                    self?.view?.presentedViewController?.dismiss(animated: false, completion: {
                                            self?.bookingRequestCompleted(result: result,
                                                                          quote: quote,
                                                                          details: bookingDetails)
                                    })
            })

        view?.showAsOverlay(item: checkoutView, animated: false)
    }

    private func bookingRequestCompleted(result: ScreenResult<TripInfo>, quote: Quote, details: BookingDetails) {
        if let trip = result.completedValue() {
            handleNewlyBooked(trip: trip,
                              quote: quote,
                              bookingDetails: details)
            return
        }

        if let error = result.errorValue() {
            view?.show(error: error)
        }

        view?.showQuoteList()
    }

    private func rebookTrip(_ trip: TripInfo) {
        var bookingDetails = BookingDetails(originLocationDetails: trip.origin.toLocationInfo())
        bookingDetails.destinationLocationDetails = trip.destination?.toLocationInfo()

        populate(with: bookingDetails)
        setViewMapPadding()
    }

    private func handleNewlyBooked(trip: TripInfo,
                                   quote: Quote,
                                   bookingDetails: BookingDetails) {
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
            if bookingDetails.isScheduled {
                view?.reset()
                showPrebookConfirmation(quote: quote,
                                        trip: trip,
                                        bookingDetails: bookingDetails)
            } else {
                view?.showAllocationScreen(trip: trip)
            }
        }
    }
}

extension KarhooBookingPresenter: BookingDetailsObserver {
    func bookingStateChanged(details: BookingDetails?) {
        if details?.originLocationDetails != nil,
            details?.destinationLocationDetails != nil {
            view?.showQuoteList()
        } else {
            view?.hideQuoteList()
            view?.setMapPadding(bottomPaddingEnabled: false)
        }

        view?.quotesAvailabilityDidUpdate(availability: true)
    }
}

extension KarhooBookingPresenter: UserStateObserver {

    func userStateUpdated(user: UserInfo?) {
        if user == nil {
            resetBookingStatus()
            tripRatingCache.clearTripRatings()
        }
    }
}

extension KarhooBookingPresenter: BookingPresenter {

    func load(view: BookingView?) {
        self.view = view
        fetchPaymentProvider()
    }

    private func fetchPaymentProvider() {
        if !Karhoo.configuration.authenticationMethod().isGuest() {
            return
        }

        paymentService.getPaymentProvider().execute(callback: { _ in})
    }

    func resetBookingStatus() {
        bookingStatus.reset()
    }

    func bookingDetails() -> BookingDetails? {
        return bookingStatus.getBookingDetails()
    }

    func populate(with bookingDetails: BookingDetails) {
        bookingStatus.reset(with: bookingDetails)
    }

    func tripCancelledBySystem(trip: TripInfo) {
        resetBookingStatus()

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

        var bookingDetails = BookingDetails(originLocationDetails: trip.origin.toLocationInfo())
        bookingDetails.destinationLocationDetails = trip.destination?.toLocationInfo()
        populate(with: bookingDetails)
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
    
    func tripWaitOnRideDetails(trip: TripInfo) {
        view?.resetAndLocate()
        view?.hideAllocationScreen()
        showRideDetailsView(trip: trip)
    }

    func tripSuccessfullyCancelled() {
        resetBookingStatus()
        view?.hideAllocationScreen()
        view?.showAlert(title: UITexts.Bookings.cancellationSuccessAlertTitle,
                        message: UITexts.Bookings.cancellationSuccessAlertMessage,
                        error: nil)
    }

    func didSelectQuote(quote: Quote) {
        view?.hideQuoteList()

        guard let bookingDetails = bookingDetails() else {
            return
        }

        showCheckoutView(quote: quote, bookingDetails: bookingDetails)
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

    func viewWillAppear() {
        setViewMapPadding()
    }

    func tripAllocated(trip: TripInfo) {
        view?.reset()
        view?.hideAllocationScreen()
        finishWithResult(.completed(result: .tripAllocated(tripInfo: trip)))
    }

    func exitPressed() {
        bookingStatus.reset()
        view?.dismiss(animated: true, completion: { [weak self] in
            self?.callback?(ScreenResult.cancelled(byUser: true))
        })
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

    func showPrebookConfirmation(quote: Quote, trip: TripInfo, bookingDetails: BookingDetails) {
        let prebookConfirmation = prebookConfirmationScreenBuilder
            .buildPrebookConfirmationScreen(quote: quote,
                                            bookingDetails: bookingDetails,
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

    func setViewMapPadding() {
        let bookingDetails = bookingStatus.getBookingDetails()
        if bookingDetails?.originLocationDetails != nil,
            bookingDetails?.destinationLocationDetails != nil {
            view?.setMapPadding(bottomPaddingEnabled: true)
        } else {
            view?.setMapPadding(bottomPaddingEnabled: false)
        }
    }
}
