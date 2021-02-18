//
//  RideDetailsPresenter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import KarhooSDK

final class KarhooRideDetailsPresenter: RideDetailsPresenter {

    internal var trip: TripInfo
    private let mailComposer: FeedbackEmailComposer
    private let tripService: TripService
    private var cancelRideBehaviour: CancelRideBehaviourProtocol?
    private weak var rideDetailsView: RideDetailsView?
    private var tripTrackingObserver: Observer<TripInfo>?
    private var tripTrackingObservable: Observable<TripInfo>?
    private let popupDialogScreenBuilder: PopupDialogScreenBuilder
    private let callback: ScreenResultCallback<RideDetailsAction>
    private let analyticsService: AnalyticsService
    private let tripFeedbackScreenBuilder: TripFeedbackScreenBuilder
    private let tripRatingCache: TripRatingCache
    private var alertHandler = AlertHandler()

    init(trip: TripInfo,
         mailComposer: FeedbackEmailComposer,
         tripService: TripService = Karhoo.getTripService(),
         popupDialogScreenBuilder: PopupDialogScreenBuilder = UISDKScreenRouting.default.popUpDialog(),
         callback: @escaping ScreenResultCallback<RideDetailsAction>,
         analyticsService: AnalyticsService = Karhoo.getAnalyticsService(),
         feedbackScreenBuilder: TripFeedbackScreenBuilder = UISDKScreenRouting.default.tripFeedbackScreen(),
         tripRatingCache: TripRatingCache = KarhooTripRatingCache()) {
        self.trip = trip
        self.mailComposer = mailComposer
        self.tripService = tripService
        self.popupDialogScreenBuilder = popupDialogScreenBuilder
        self.callback = callback
        self.analyticsService = analyticsService
        self.tripFeedbackScreenBuilder = feedbackScreenBuilder
        self.tripRatingCache = tripRatingCache

        self.setUpTripListener()
    }

    deinit {
        unsubscribeTripListener()
    }

    func bind(view: RideDetailsView) {
        self.rideDetailsView = view
        view.setUpWith(trip: trip,
                       mailComposer: mailComposer)
        setNavigationBarWithScheduledDate()

        tripRatingCache.tripRated(tripId: trip.tripId) ? view.hideFeedbackOptions() : ()
    }

    func set(cancelRideBehaviour: CancelRideBehaviourProtocol, alertHandler: AlertHandler) {
        self.cancelRideBehaviour = cancelRideBehaviour
        self.cancelRideBehaviour?.delegate = self
        self.alertHandler = alertHandler
    }

    func didPressTrackTrip() {
        finishWithResult(ScreenResult.completed(result: .trackTrip(trip)))
    }

    func didPressRebookTrip() {
        finishWithResult(ScreenResult.completed(result: .rebookTrip(trip)))
    }

    func didPressCancelTrip() {
        cancelRideBehaviour?.cancelPressed()
    }

    func didPresssReportIsssue() {
        if mailComposer.reportIssueWith(trip: trip) {
            return
        }
    }

    func didPressBaseFareExplanation() {
        let baseFarePopup = popupDialogScreenBuilder.buildPopupDialogScreen(callback: { [weak self] _ in
            self?.rideDetailsView?.dismiss(animated: true, completion: nil)
        })

        baseFarePopup.modalPresentationStyle = .overCurrentContext
        baseFarePopup.modalTransitionStyle = .crossDissolve

        self.rideDetailsView?.present(baseFarePopup, animated: true, completion: nil)
    }

    func didPressTripFeedback() {
        let feedbackScreen = tripFeedbackScreenBuilder.buildFeedbackScreen(tripId: trip.tripId,
                                                                           callback: { [weak self] result in
            switch result {
            case .completed: self?.rideDetailsView?.hideFeedbackOptions()
            default: break
            }

            self?.rideDetailsView?.pop()
        })
        
        self.rideDetailsView?.push(feedbackScreen)
    }

    private func setNavigationBarWithScheduledDate() {
        if let date = trip.dateScheduled {
            let dateFormatter = KarhooDateFormatter(timeZone: trip.origin.timezone())
            rideDetailsView?.set(navigationTitle: dateFormatter.display(detailStyleDate: date))
        }
    }

    private func setUpTripListener() {
        if self.trip.state == .completed || TripInfoUtility.isCancelled(trip: self.trip) {
            return
        }

        tripTrackingObserver = Observer<TripInfo>.value { [weak self] trip in
            self?.updated(trip: trip)
        }

        tripTrackingObservable = tripService.trackTrip(identifier: tripIdentifier()).observable()

        if let observer = tripTrackingObserver {
            tripTrackingObservable?.subscribe(observer: observer)
        }
    }

    private func updated(trip: TripInfo) {
        rideDetailsView?.setUpWith(trip: trip, mailComposer: mailComposer)

        if trip.state == .driverCancelled {
            rideDetailsView?.showAlert(title: UITexts.Trip.tripCancelledByDispatchAlertTitle,
                                       message: UITexts.Trip.tripCancelledByDispatchAlertMessage,
                                       error: nil)
            unsubscribeTripListener()
        }
    }

    private func unsubscribeTripListener() {
        tripTrackingObservable?.unsubscribe(observer: tripTrackingObserver)
    }

    private func finishWithResult(_ result: ScreenResult<RideDetailsAction>) {
        self.callback(result)
    }
    
    public func sendTripRate(rating: Int) {
        let payload: [String: Any] = ["tripId": trip.tripId,
                                      "source": "MOBILE",
                                      "type": "STARS",
                                      "rating": rating,
                                      "timestamp": Date().timeIntervalSince1970]
        
        analyticsService.send(eventName: .tripRatingSubmitted,
                              payload: payload)
    }

    fileprivate func tripIdentifier() -> String {
        if Karhoo.configuration.authenticationMethod().isGuest() {
            return trip.followCode
        } else {
            return trip.tripId
        }
    }
}

extension KarhooRideDetailsPresenter: CancelRideDelegate {

    public func sendCancelRideNetworkRequest(callback: @escaping CallbackClosure<KarhooVoid>) {
        let tripCancellation = TripCancellation(tripId: tripIdentifier(), cancelReason: .notNeededAnymore)

        tripService.cancel(tripCancellation: tripCancellation)
            .execute(callback: { [weak self] result in
                guard let self = self else {
                    return
                }

                if result.isSuccess() {
                    self.rideDetailsView?.showAlert(title: UITexts.Bookings.cancellationSuccessAlertTitle,
                                                     message: UITexts.Bookings.cancellationSuccessAlertMessage, 
                                                     error: nil)
                }

                callback(result)
            })
    }
    
    public func sendCancellationFeeNetworkRequest(callback: @escaping CallbackClosure<CancellationFee>) {
        tripService.cancellationFee(identifier: tripIdentifier())
            .execute(callback: { [weak self] result in
                guard let self = self else {
                    return
                }
                
                if(result.isSuccess()) {
                    guard let cancellationFee = result.successValue() else {
                        self.alertHandler.show(title: UITexts.Trip.tripCancelBookingConfirmationAlertTitle,
                                                         message: UITexts.Bookings.cancellationFeeContinue,
                                                         actions: [
                                                           AlertAction(title: UITexts.Generic.no, style: .default, handler: nil),
                                                           AlertAction(title: UITexts.Generic.yes, style: .default, handler: { [weak self] _ in
                                                            self?.cancelRideBehaviour?.triggerCancelRide()
                                                           })
                                                       ])
                        return
                    }
                    let feeString = CurrencyCodeConverter.toPriceString(price: Double(cancellationFee.fee.value), currencyCode: cancellationFee.fee.currency)
                    self.alertHandler.show(title: UITexts.Trip.tripCancelBookingConfirmationAlertTitle,
                                                    message: String(format: UITexts.Bookings.cancellationFeeCharge, feeString),
                                                    actions: [
                                                      AlertAction(title: UITexts.Generic.no, style: .default, handler: nil),
                                                      AlertAction(title: UITexts.Generic.yes, style: .default, handler: { [weak self] _ in
                                                        self?.cancelRideBehaviour?.triggerCancelRide()
                                                      })
                                                  ])
                }
//                callback(result)
            })
    }
    

    public func showLoadingOverlay() {
        rideDetailsView?.showLoading()
    }

    public func hideLoadingOverlay() {
        rideDetailsView?.hideLoading()
    }
}
