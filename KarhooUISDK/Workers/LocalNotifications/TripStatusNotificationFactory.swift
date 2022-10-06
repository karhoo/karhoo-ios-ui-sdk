//
// Created by Aleksander Wedrychowski on 06/10/2022.
// Copyright (c) 2022 Flit Technologies Ltd. All rights reserved.
//

import KarhooSDK

protocol TripStatusNotificationFactory: AnyObject {
    func notification(for tripInfo: TripInfo) -> LocalNotification?
}

final class KarhooTripStatusNotificationFactory: TripStatusNotificationFactory {

    func notification(for tripInfo: TripInfo) -> LocalNotification? {
        switch tripInfo.state {
        default:
            return LocalNotification(
                title: "State: \(tripInfo.state.rawValue)",
                body: "",
                identifier: tripInfo.tripId
            )
        }
    }
}
