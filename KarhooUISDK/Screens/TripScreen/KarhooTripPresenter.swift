//
//  JourneyViewPresenter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import KarhooSDK

final class KarhooJourneyPresenter: JourneyPresenter,
                                    CancelRideDelegate {
    
    private let logger: Logger
    private weak var journeyView: JourneyView?
    private var trip: TripInfo
    private let analytics: Analytics
    private var previousState: TripState = .unknown
    private let tripService: TripService
    private let driverTrackingService: DriverTrackingService
    private let phoneCaller: PhoneNumberCallerProtocol
    private var cameraShouldFollowCar: Bool = true
    private let cancelRide: CancelRideBehaviourProtocol!
    private lazy var currentlyListeningForDriverUpdates: Bool = false
    private var driverTrackingObservable: Observable<DriverTrackingInfo>?
    private var driverTrackingObserver: Observer<DriverTrackingInfo>?
    private var tripTrackingObservable: Observable<TripInfo>?
    private var tripTrackingObserver: Observer<TripInfo>?
    private let rideDetailsScreenBuilder: RideDetailsScreenBuilder
    private let callback: ScreenResultCallback<TripScreenResult>
    private let tripInfoPollingInterval: TimeInterval = 30

    init(initialTrip: TripInfo,
         service: TripService = Karhoo.getTripService(),
         driverTrackingService: DriverTrackingService = Karhoo.getDriverTrackingService(),
         cancelRideBehaviour: CancelRideBehaviourProtocol? = nil,
         phoneNumberCaller: PhoneNumberCallerProtocol = PhoneNumberCaller(),
         logger: Logger = DebugLogger(),
         analytics: Analytics = KarhooAnalytics(),
         rideDetailsScreenBuilder: RideDetailsScreenBuilder = UISDKScreenRouting.default.rideDetails(),
         callback: @escaping ScreenResultCallback<TripScreenResult>) {
        self.trip = initialTrip
        self.logger = logger
        self.phoneCaller = phoneNumberCaller
        self.tripService = service
        self.driverTrackingService = driverTrackingService
        self.analytics = analytics
        self.cancelRide = cancelRideBehaviour
        self.rideDetailsScreenBuilder = rideDetailsScreenBuilder
        self.callback = callback
        self.cancelRide?.delegate = self
    }

    deinit {
        tripTrackingObservable?.unsubscribe(observer: tripTrackingObserver)
        stopListeningForDriverLocationUpdates()
    }

    func load(view: JourneyView?) {
        journeyView = view
        journeyView?.set(locateButtonHidden: true)
    }

    func userMovedMap() {
        journeyView?.set(locateButtonHidden: false)
        cameraShouldFollowCar = false
    }

    func screenDidLayoutSubviews() {
        journeyView?.plotPinsOnMap()
        journeyView?.focusMapOnRoute()
        forceSetStatusAccordingToTrip()
    }

    func screenDidDisappear() {
        tripTrackingObservable?.unsubscribe(observer: tripTrackingObserver)
        stopListeningForDriverLocationUpdates()
    }

    func screenAppeared() {
        listenForDriverLocationUpdates()
        let observer = Observer<TripInfo>.value { [weak self] tripInfo in
           self?.updated(trip: tripInfo)
        }
        let observable = tripService.trackTrip(identifier: trip.tripId).observable(pollTime: tripInfoPollingInterval)
        observable.subscribe(observer: observer)

        tripTrackingObservable = observable
        tripTrackingObserver = observer
    }

    func cancelBookingPressed() {
        cancelRide.triggerCancelRide()
    }

    func callDriverPressed() {
        phoneCaller.call(number: trip.vehicle.driver.phoneNumber)
        analytics.userCalledDriver()
    }

    func callFleetPressed() {
        phoneCaller.call(number: trip.fleetInfo.phoneNumber)
    }

    private func listenForDriverLocationUpdates() {
        if TripInfoUtility.canTrackDriver(trip: trip) && currentlyListeningForDriverUpdates == false {

            let observer = Observer<DriverTrackingInfo>.value { [weak self] info in
                self?.updated(info: info)
            }

            let observable = driverTrackingService.trackDriver(tripId: trip.tripId).observable()
            observable.subscribe(observer: observer)
            currentlyListeningForDriverUpdates = true

            driverTrackingObservable = observable
            driverTrackingObserver = observer
        }
    }

    private func stopListeningForDriverLocationUpdates() {
        if currentlyListeningForDriverUpdates == true {
            driverTrackingObservable?.unsubscribe(observer: driverTrackingObserver)
            currentlyListeningForDriverUpdates = false
        }
    }

    func locatePressed() {
        focusMap()
    }

    func updated(info: DriverTrackingInfo) {
        journeyView?.update(driverLocation: info.position.toCLLocation())

        if cameraShouldFollowCar == true {
            focusMap()
        }
    }

    func updated(trip: TripInfo) {
        self.trip = trip
        listenForDriverLocationUpdates()
        updateAccordingToTrip()
    }

    func tripUpdateFailed(_ error: Error?) {
        logger.log("Trip Update Failed \(String(describing: error.debugDescription))")
    }

    func showLoadingOverlay() {
        journeyView?.showLoading()
    }

    func hideLoadingOverlay() {
        journeyView?.hideLoading()
    }

    func userDidCloseJourney() {
        finishWithResult(.completed(result: .closed))
    }

    func sendCancelRideNetworkRequest(callback: @escaping CallbackClosure<KarhooVoid>) {
        let tripCancellation = TripCancellation(tripId: trip.tripId,
                                                cancelReason: .notNeededAnymore)
        tripService.cancel(tripCancellation: tripCancellation)
                .execute(callback: { result in
                    callback(result)
                })
    }

    private func updateAccordingToTrip() {
        setStatusAccordingToTrip(animated: true)
        updateBookingDetails()
    }

    private func focusMap() {
        cameraShouldFollowCar = true

        if trip.state == .driverEnRoute || trip.state == .arrived {
            journeyView?.focusMapOnDriverAndPickup()
            return
        }

        if trip.state == .passengerOnBoard {
            journeyView?.focusMapOnDriverAndDestination()
            return
        }

        journeyView?.focusMapOnRoute()
    }

    private func forceSetStatusAccordingToTrip() {
        previousState = .unknown
        setStatusAccordingToTrip(animated: false)
    }

    private func setStatusAccordingToTrip(animated: Bool) {
        guard trip.state != previousState else {
            logger.log("Trip status update REJECTED - current trip state is same as previous!")
            return
        }

        analytics.tripStateChanged(to: trip.state.rawValue)

        let userMarkerVisible = TripInfoUtility.canCancel(trip: trip)
        journeyView?.set(userMarkerVisible: userMarkerVisible)

        switch trip.state {
        case .completed:
            tripCompleted(trip)
        case .bookerCancelled:
            showAlertThenCloseView(title: UITexts.Bookings.cancellationSuccessAlertTitle,
                                   message: UITexts.Bookings.cancellationSuccessAlertMessage)
        case .driverCancelled:
            showAlertThenCloseView(title: UITexts.Journey.journeyCancelledByDispatchAlertTitle,
                                   message: UITexts.Journey.journeyCancelledByDispatchAlertMessage)
        case .karhooCancelled:
            finishWithResult(.completed(result: .closed))
        case .noDriversAvailable:
            showAlertThenCloseView(title: UITexts.Journey.noDriversAvailableTitle,
                                   message: String(format: UITexts.Journey.noDriversAvailableMessage,
                                                   trip.fleetInfo.name))
        default:
            break
        }

        journeyView?.set(trip: trip)

        previousState = trip.state
    }

    private func updateBookingDetails() {
        journeyView?.setAddressBar(with: trip)
    }

    private func tripCompleted(_ trip: TripInfo) {
        let rideDetails = rideDetailsScreenBuilder.buildOverlayRideDetailsScreen(trip: trip,
                                                                                callback: { [weak self] result in
            guard let screenResult = result.completedValue() else {
                self?.finishWithResult(.completed(result: .closed))
                return
            }

            switch screenResult {
            case .rebookTrip(let trip):
                var bookingDetails = BookingDetails(originLocationDetails: trip.origin.toLocationInfo())
                bookingDetails.destinationLocationDetails = trip.destination?.toLocationInfo()
                self?.finishWithResult(.completed(result: .rebookTrip(rebookDetails: bookingDetails)))
            default:
                self?.finishWithResult(.completed(result: .closed))
            }
        })

        journeyView?.present(rideDetails, animated: true, completion: nil)
    }

    private func showAlertThenCloseView(title: String, message: String) {
        let action = AlertAction(title: UITexts.Generic.ok, style: .default, handler: { [weak self] _ in
            self?.finishWithResult(ScreenResult.completed(result: .closed))
        })

        journeyView?.showAlert(title: title, message: message, actions: [action])
    }

    private func finishWithResult(_ result: ScreenResult<TripScreenResult>) {
        self.callback(result)
    }
}
