//
// Created by Aleksander Wedrychowski on 06/10/2022.
// Copyright (c) 2022 Flit Technologies Ltd. All rights reserved.
//

import KarhooSDK

/// Object should observe TripInfo changes and send propoer data to LocalNotification handler.
protocol TripStatusNotificationWorker: AnyObject {
    func start()
    func stop()
}

final class KarhooTripStatusNotificationWorker: TripStatusNotificationWorker, TripUpdateListener {

    static let shared = KarhooTripStatusNotificationWorker()

    private let TripInfoUpdateProvider: TripInfoUpdateProvider
    private let localNotificationWorker: LocalNotificationWorker
    private let tripStatusNotificationFactory: TripStatusNotificationFactory

    init(
        TripInfoUpdateProvider: TripInfoUpdateProvider = KarhooTripInfoUpdateProvider.shared,
        localNotificationWorker: LocalNotificationWorker = KarhooLocalNotificationWorker(),
        tripStatusNotificationFactory: TripStatusNotificationFactory = KarhooTripStatusNotificationFactory()
    ) {
        self.TripInfoUpdateProvider = TripInfoUpdateProvider
        self.localNotificationWorker = localNotificationWorker
        self.tripStatusNotificationFactory = tripStatusNotificationFactory
    }

    func start() {
        TripInfoUpdateProvider.add(listener: self)
    }

    func stop() {
        TripInfoUpdateProvider.remove(listener: self)
    }

    func tripStatusChanged(tripInfo: TripInfo, currentState: TripState) {
        guard let notification = tripStatusNotificationFactory.notification(
            for: tripInfo,
            withState: currentState
        ) else {
            return
        }

        localNotificationWorker.show(notification: notification)
    }
}
