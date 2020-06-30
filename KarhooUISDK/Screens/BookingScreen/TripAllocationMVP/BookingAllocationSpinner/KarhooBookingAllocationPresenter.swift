//
//  KarhooBookingAllocationSpinnerPresenter.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import KarhooSDK

final class KarhooBookingAllocationSpinnerPresenter: BookingAllocationSpinnerPresenter {

    private let appStateNotifier: AppStateNotifierProtocol
    private weak var view: BookingAllocationSpinnerView?

    init(appStateNotifier: AppStateNotifierProtocol = AppStateNotifier(),
         view: BookingAllocationSpinnerView) {
        self.appStateNotifier = appStateNotifier
        self.view = view
    }

    func startMonitoringAppState() {
        appStateNotifier.register(listener: self)
    }

    func stopMonitoringAppState() {
        appStateNotifier.remove(listener: self)
    }
}

extension KarhooBookingAllocationSpinnerPresenter: AppStateChangeDelegate {

    func appDidBecomeActive() {
        view?.startRotation()
    }

    func appWillResignActive() {
        view?.stopRotation()
    }
}
