//
//  BookingMapPresenter.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 20.03.2024.
//  Copyright © 2024 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import Combine
import KarhooSDK

final class KarhooBookingMapScreenPresenter: BookingMapScreenPresenter {
    
    private weak var view: BookingMapScreen?
    private let featureFlagsProvider: FeatureFlagProvider
    private let journeyDetailsManager: JourneyDetailsManager
    private let analytics: Analytics
    private let coverageCheckWorker: CoverageCheckWorker
    private let ridesScreenBuilder: RidesScreenBuilder
    private let tripScreenBuilder: TripScreenBuilder
    private let urlOpener: URLOpener
    private let paymentService: PaymentService
    private let vehicleRulesProvider: VehicleRulesProvider
    private(set) var callback: ScreenResultCallback<BookingMapScreenResult>?
    
    var hasCoverageInTheAreaPublisher = CurrentValueSubject<Bool?, Never>(nil)
    var isAsapEnabledPublisher = CurrentValueSubject<Bool, Never>(false)
    var isScheduleForLaterEnabledPublisher = CurrentValueSubject<Bool, Never>(false)
    
    // MARK: Lifecycle
    init(
        featureFlagsProvider: FeatureFlagProvider = KarhooFeatureFlagProvider(),
        analytics: Analytics = KarhooUISDKConfigurationProvider.configuration.analytics(),
        journeyDetailsManager: JourneyDetailsManager = KarhooJourneyDetailsManager.shared,
        coverageCheckWorker: CoverageCheckWorker = KarhooCoverageCheckWorker(),
        ridesScreenBuilder: RidesScreenBuilder = UISDKScreenRouting.default.rides(),
        tripScreenBuilder: TripScreenBuilder = UISDKScreenRouting.default.tripScreen(),
        urlOpener: URLOpener = KarhooURLOpener(),
        paymentService: PaymentService = Karhoo.getPaymentService(),
        vehicleRulesProvider: VehicleRulesProvider = KarhooVehicleRulesProvider(),
        callback: ScreenResultCallback<BookingMapScreenResult>? = nil
    ) {
        self.featureFlagsProvider = featureFlagsProvider
        self.analytics = analytics
        self.journeyDetailsManager = journeyDetailsManager
        self.coverageCheckWorker = coverageCheckWorker
        self.ridesScreenBuilder = ridesScreenBuilder
        self.tripScreenBuilder = tripScreenBuilder
        self.urlOpener = urlOpener
        self.paymentService = paymentService
        self.vehicleRulesProvider = vehicleRulesProvider
        self.callback = callback
    }
    
    func load(view: BookingMapScreen?) {
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
    
    // MARK: - BookingMapScreenPresenter
    func exitPressed() {
        journeyDetailsManager.reset()
        view?.dismiss(animated: true, completion: { [weak self] in
            self?.callback?(ScreenResult.cancelled(byUser: true))
        })
    }
    
    func asapRidePressed() {
        completeWithResult()
    }
    
    func prebookRidePressed() {
        completeWithResult()
    }
    
    private func completeWithResult() {
        let result = journeyDetailsManager.getJourneyDetails()
        callback?(ScreenResult.completed(result: BookingMapScreenResult(journeyDetails: result)))
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
    
    // MARK: - Utils
    private func isSdkVersionSupported() -> Bool {
        let flags = featureFlagsProvider.get()
        let adyenPaymentManagerName = "KarhooUISDK.AdyenPaymentManager"
        let paymentManagerName = String(describing: KarhooUISDKConfigurationProvider.configuration.paymentManager.self)
    
        return !(flags.adyenAvailable == false && paymentManagerName == adyenPaymentManagerName)
    }
    
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
    
    private func resetJourneyDetails() {
        journeyDetailsManager.reset()
    }
    
    private func populate(with journeyDetails: JourneyDetails) {
        journeyDetailsManager.reset(with: journeyDetails)
    }
    
    // MARK: - Rides
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
                resetJourneyDetails()
                view?.focusMap()
            case .rebookTrip(let trip):
                rebookTrip(trip)
            }
        }
    }
    
    private func goToTripView(trip: TripInfo) {
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
            let tripView = tripScreenBuilder.buildTripScreen(
                trip: trip,
                callback: tripViewCallback
            )
            view?.present(tripView, animated: true, completion: nil)
        }
    }
    
    private func rebookTrip(_ trip: TripInfo) {
        var journeyDetails = JourneyDetails(originLocationDetails: trip.origin.toLocationInfo())
        journeyDetails.destinationLocationDetails = trip.destination?.toLocationInfo()

        populate(with: journeyDetails)
    }
    
    private func tripViewCallback(result: ScreenResult<TripScreenResult>) {
        view?.dismiss(animated: true, completion: nil)
        switch result.completedValue() {
        case .some(.rebookTrip(let details)):
            populate(with: details)
        default: break
        }
    }
}

// MARK: - BookingDetailsObserver
extension KarhooBookingMapScreenPresenter: JourneyDetailsObserver {
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
