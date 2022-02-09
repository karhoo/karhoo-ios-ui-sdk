//
//  TripViewPresenter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import KarhooSDK

final class KarhooTripPresenter: TripPresenter,
                                 CancelRideDelegate {
    
    private let logger: Logger
    private weak var tripView: TripView?
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
         analytics: Analytics = KarhooUISDKConfigurationProvider.configuration.analytics(),
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

    func load(view: TripView?) {
        tripView = view
        tripView?.set(locateButtonHidden: true)
    }

    func userMovedMap() {
        tripView?.set(locateButtonHidden: false)
        cameraShouldFollowCar = false
    }

    func screenDidLayoutSubviews() {
        tripView?.plotPinsOnMap()
        tripView?.focusMapOnRoute()
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

        analyticsScreenOpened()
    }

    func cancelBookingPressed() {
        cancelRide.cancelPressed()
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
        tripView?.update(driverLocation: info.position.toCLLocation())

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
        tripView?.showLoading()
    }

    func hideLoadingOverlay() {
        tripView?.hideLoading()
    }
    
    func handleSuccessfulCancellation() {
        finishWithResult(ScreenResult.completed(result: .closed))
    }

    func userDidCloseTrip() {
        finishWithResult(.completed(result: .closed))
    }

    private func updateAccordingToTrip() {
        setStatusAccordingToTrip(animated: true)
        updateBookingDetails()
    }

    private func focusMap() {
        cameraShouldFollowCar = true

        if trip.state == .driverEnRoute || trip.state == .arrived {
            tripView?.focusMapOnDriverAndPickup()
            return
        }

        if trip.state == .passengerOnBoard {
            tripView?.focusMapOnDriverAndDestination()
            return
        }

        tripView?.focusMapOnRoute()
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
        tripView?.set(userMarkerVisible: userMarkerVisible)

        switch trip.state {
        case .completed:
            tripCompleted(trip)
        case .driverCancelled:
            showAlertThenCloseView(title: UITexts.Trip.tripCancelledByDispatchAlertTitle,
                                   message: UITexts.Trip.tripCancelledByDispatchAlertMessage)
        case .karhooCancelled:
            finishWithResult(.completed(result: .closed))
        case .noDriversAvailable:
            showAlertThenCloseView(title: UITexts.Trip.noDriversAvailableTitle,
                                   message: String(format: UITexts.Trip.noDriversAvailableMessage,
                                                   trip.fleetInfo.name))
        default:
            break
        }

        tripView?.set(trip: trip)

        previousState = trip.state
    }

    private func updateBookingDetails() {
        tripView?.setAddressBar(with: trip)
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

        tripView?.present(rideDetails, animated: true, completion: nil)
    }

    private func showAlertThenCloseView(title: String, message: String) {
        let action = AlertAction(title: UITexts.Generic.ok, style: .default, handler: { [weak self] _ in
            self?.finishWithResult(ScreenResult.completed(result: .closed))
        })

        tripView?.showAlert(title: title, message: message, error: nil, actions: [action])
    }

    private func finishWithResult(_ result: ScreenResult<TripScreenResult>) {
        self.callback(result)
    }

    // MARK: - Analytics

    private func analyticsScreenOpened() {
        analytics.trackTripOpened(
            tripDetails: trip,
            isGuest: Karhoo.configuration.authenticationMethod().isGuest()
        )
    }
}
