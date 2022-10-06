//
// Created by Aleksander Wedrychowski on 06/10/2022.
// Copyright (c) 2022 Flit Technologies Ltd. All rights reserved.
//

import KarhooSDK

final class TripStatusNotificationWorker: TripUpdateListener {

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

    func tripStatusChanged(tripInfo: TripInfo) {
        guard let notification = tripStatusNotificationFactory.notification(for: tripInfo) else {
            return
        }

        localNotificationWorker.show(notification: notification)
    }
}
