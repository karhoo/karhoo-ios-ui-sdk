//
//  KarhooBookingRequestPresenter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooSDK

final class KarhooBookingRequestPresenter: BookingRequestPresenter {

    private weak var view: BookingRequestView?
    private let quote: Quote
    private let bookingDetails: BookingDetails
    private let userService: UserService
    private let tripService: TripService
    private let callback: ScreenResultCallback<TripInfo>
    private let analytics: Analytics
    private let appStateNotifier: AppStateNotifierProtocol
    private var trip: TripInfo?
    private var flightNumber: String?
    private var comments: String?
    private var bookingRequestInProgress: Bool = false
    private var flightDetailsScreenIsPresented: Bool = false
    private let flightDetailsScreenBuilder: FlightDetailsScreenBuilder
    private let baseFareDialogBuilder: PopupDialogScreenBuilder
    private let paymentNonceProvider: PaymentNonceProvider

    init(quote: Quote,
         bookingDetails: BookingDetails,
         userService: UserService = Karhoo.getUserService(),
         tripService: TripService = Karhoo.getTripService(),
         analytics: Analytics = KarhooAnalytics(),
         appStateNotifier: AppStateNotifierProtocol = AppStateNotifier(),
         flightDetailsScreenBuilder: FlightDetailsScreenBuilder = KarhooUI().screens().flightDetails(),
         paymentNonceProvider: PaymentNonceProvider = PaymentFactory().nonceProvider(),
         baseFarePopupDialogBuilder: PopupDialogScreenBuilder = UISDKScreenRouting.default.popUpDialog(),
         callback: @escaping ScreenResultCallback<TripInfo>) {
        self.quote = quote
        self.bookingDetails = bookingDetails
        self.userService = userService
        self.tripService = tripService
        self.callback = callback
        self.appStateNotifier = appStateNotifier
        self.analytics = analytics
        self.flightDetailsScreenBuilder = flightDetailsScreenBuilder
        self.baseFareDialogBuilder = baseFarePopupDialogBuilder
        self.paymentNonceProvider = paymentNonceProvider
        appStateNotifier.register(listener: self)
    }

    func load(view: BookingRequestView) {
        self.view = view
        setUpBookingButtonState()
        view.set(quote: quote)

        if quote.source == .market {
            view.set(price: CurrencyCodeConverter.quoteRangePrice(quote: quote))
        } else {
            view.set(price: CurrencyCodeConverter.toPriceString(quote: quote))
        }

        view.set(quoteType: quote.quoteType.description)
        view.set(baseFareExplanationHidden: quote.quoteType == .fixed)
        paymentNonceProvider.set(baseViewController: view)
        configureQuoteView()
        view.paymentView(hidden: userService.getCurrentUser()?.paymentProvider?.provider.type == .adyen)
    }

    func bookTripPressed() {
        submitBooking()
    }

    func didPressAddFlightDetails() {
        var dismissCallback: (() -> Void)?
        let flightDetailsScreen = flightDetailsScreenBuilder
            .buildFlightDetailsScreen(completion: { [weak self] result in
            dismissCallback?()
            self?.flightDetailsScreenIsPresented = false

            guard let flightDetails = result.completedValue() else {
                return
            }

            self?.didAdd(flightDetails: flightDetails)
        })

        dismissCallback = {
            flightDetailsScreen.dismiss(animated: true, completion: nil)
        }

        view?.present(flightDetailsScreen, animated: true, completion: nil)
        self.flightDetailsScreenIsPresented = true
    }

    func didPressClose() {
        view?.showBookingRequestView(false)
    }

    func didPressFareExplanation() {
        guard bookingRequestInProgress == false else {
            return
        }

        let popupDialog = baseFareDialogBuilder.buildPopupDialogScreen(callback: { [weak self] _ in
            self?.view?.dismiss(animated: true, completion: nil)
        })

        popupDialog.modalTransitionStyle = .crossDissolve
        view?.showAsOverlay(item: popupDialog, animated: true)
    }

    func screenHasFadedOut() {
        if let trip = self.trip {
            callback(ScreenResult.completed(result: trip))
        } else {
            callback(ScreenResult.cancelled(byUser: false))
        }
    }

    private func didAdd(flightDetails: FlightDetails) {
        self.flightDetailsScreenIsPresented = false
        self.flightNumber = flightDetails.flightNumber
        self.comments = flightDetails.comments

        submitBooking()
    }

    private func configureQuoteView() {
        if bookingDetails.isScheduled {
            configurePrebookState()
            return
        }
        configureForAsapState()
    }

    private func configurePrebookState() {
        guard let timeZone = bookingDetails.originLocationDetails?.timezone() else {
            return
        }

        let prebookFormatter = KarhooDateFormatter(timeZone: timeZone)

        view?.setPrebookState(timeString: prebookFormatter.display(shortStyleTime: bookingDetails.scheduledDate),
                                dateString: prebookFormatter.display(mediumStyleDate: bookingDetails.scheduledDate))
    }

    private func configureForAsapState() {
        view?.setAsapState(qta: QtaStringFormatter().qtaString(min: quote.vehicle.qta.lowMinutes,
                                                                 max: quote.vehicle.qta.highMinutes))
    }

    private func setUpBookingButtonState() {
        if TripInfoUtility.isAirportBooking(bookingDetails) {
            view?.setAddFlightDetailsState()
        } else {
            view?.setDefaultState()
        }
    }

    private func submitBooking() {
        bookingRequestInProgress = true
        view?.setRequestingState()

        guard let currentUser = userService.getCurrentUser(),
              let currentOrg = userService.getCurrentUser()?.organisations.first else {
            view?.showAlert(title: UITexts.Errors.somethingWentWrong,
                            message: UITexts.Errors.getUserFail,
                            error: nil)
            return
        }

        if let destination = bookingDetails.destinationLocationDetails {
            analytics.bookingRequested(destination: destination,
                                      dateScheduled: bookingDetails.scheduledDate,
                                      quote: quote)
        }

        if let nonce = view?.getPaymentNonce() {
            bookTrip(withPaymentNonce: Nonce(nonce: nonce), user: currentUser)
        } else {
            paymentNonceProvider.getPaymentNonce(user: currentUser,
                                                 organisation: currentOrg,
                                                 quote: quote) { [weak self] result in
                switch result {
                case .completed(let result): handlePaymentNonceProviderResult(result)
                case .cancelledByUser: self?.view?.setDefaultState()
                }
            }
        }

        func handlePaymentNonceProviderResult(_ paymentNonceResult: PaymentNonceProviderResult) {
            switch paymentNonceResult {
            case .nonce(let nonce): bookTrip(withPaymentNonce: nonce, user: currentUser)
            case .cancelledByUser:
                view?.setDefaultState()
            case .failedToAddCard(let error):
                self.view?.show(error: error)
                view?.setDefaultState()
            default:
                self.view?.showAlert(title: UITexts.Generic.error, message: UITexts.Errors.somethingWentWrong,
                                     error: nil)
                view?.setDefaultState()
            }
        }
    }

    private func bookTrip(withPaymentNonce nonce: Nonce, user: UserInfo) {
        var tripBooking = TripBooking(quoteId: quote.id,
                                      passengers: Passengers(additionalPassengers: 0,
                                                             passengerDetails: [PassengerDetails(user: user)]),
                                      flightNumber: flightNumber)

        tripBooking.paymentNonce = nonce.nonce
        
        if userService.getCurrentUser()?.paymentProvider?.provider.type == .adyen {
            tripBooking.meta = ["trip_id": nonce.nonce]
        }
        
        tripService.book(tripBooking: tripBooking)
            .execute(callback: { [weak self] (result: Result<TripInfo>) in
                self?.bookingRequestInProgress = false
                self?.handleBookTrip(result: result)
            })
    }

    private func handleBookTrip(result: Result<TripInfo>) {
        guard let trip = result.successValue() else {
            view?.setDefaultState()

            if result.errorValue()?.type == .couldNotBookTripPaymentPreAuthFailed {
                view?.retryAddPaymentMethod()
            } else {
                callback(ScreenResult.failed(error: result.errorValue()))
            }

            return
        }

        self.trip = trip
        view?.showBookingRequestView(false)
    }

    deinit {
        appStateNotifier.remove(listener: self)
    }
}

extension KarhooBookingRequestPresenter: AppStateChangeDelegate {
    func appDidEnterBackground() {
        if bookingRequestInProgress == false,
            flightDetailsScreenIsPresented == false {
            self.didPressClose()
        }
    }
}
