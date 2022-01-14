//
//  KarhooTripAllocationView.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK
import UIKit

public struct KHTripAllocationViewID {
    public static let cancelButton = "cancel_button_view"
}

final class KarhooTripAllocationView: UIView, TripAllocationView {

    private var presenter: TripAllocationPresenter!
    private weak var actions: TripAllocationActions?

    private var cancelButtonView: KarhooCancelButtonView!
    private var loadingSpinnerView: KarhooBookingAllocationSpinner!
    private var rollingTextView: RollingTextView!

    init() {
        super.init(frame: .zero)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }

    func set(actions: TripAllocationActions) {
        self.actions = actions
    }

    func presentScreen(forTrip trip: TripInfo) {
        alpha = 1
        loadingSpinnerView.fadeInAndAnimate()

        rollingTextView.animate(title: UITexts.TripAllocation.findingYourRide,
                                subtitles: [UITexts.TripAllocation.allocatingTripOne,
                                            UITexts.TripAllocation.allocatingTripTwo])
        presenter.startMonitoringTrip(trip: trip)
    }
    
    private func setUpView() {
        translatesAutoresizingMaskIntoConstraints = false
        alpha = 0
        presenter = KarhooTripAllocationPresenter(view: self)
        
        loadingSpinnerView = KarhooBookingAllocationSpinner()
        addSubview(loadingSpinnerView)
        
        rollingTextView = RollingTextView()
        addSubview(rollingTextView)
        
        cancelButtonView = KarhooCancelButtonView()
        cancelButtonView.accessibilityIdentifier = KHTripAllocationViewID.cancelButton
        cancelButtonView.set(actions: self)
        addSubview(cancelButtonView)
        
        setUpConstraints()
    }
    
    private func setUpConstraints() {
        _ = [rollingTextView.topAnchor.constraint(equalTo: self.topAnchor, constant: 60.0),
             rollingTextView.centerXAnchor.constraint(equalTo: self.centerXAnchor)].map { $0.isActive = true }
        
        _ = [loadingSpinnerView.topAnchor.constraint(equalTo: self.topAnchor),
             loadingSpinnerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
             loadingSpinnerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
             loadingSpinnerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)].map { $0.isActive = true }
        
        _ = [cancelButtonView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
             cancelButtonView.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                      constant: -15.0)].map { $0.isActive = true }
    }

    func dismissScreen() {
        presenter.stopMonitoringTrip()
        self.alpha = 0
    }
    
    func tripDriverAllocationDelayed(trip: TripInfo) {
        actions?.tripDriverAllocationDelayed(trip: trip)
    }

    func tripAllocated(trip: TripInfo) {
        actions?.tripAllocated(trip: trip)
    }

    func tripCancellationRequestSucceeded() {
        actions?.userSuccessfullyCancelledTrip()
    }

    func tripCancelledBySystem(trip: TripInfo) {
        actions?.tripCancelledBySystem(trip: trip)
    }

    func tripCancellationRequestFailed(error: KarhooError?, trip: TripInfo) {
        actions?.cancelTripFailed(error: error, trip: trip)
    }

    func resetCancelButtonProgress() {
        cancelButtonView.reset()
    }
}

extension KarhooTripAllocationView: CancelButtonActions {

    func userRequestedTripCancellation() {
        presenter.cancelTrip()
    }
}
