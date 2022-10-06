//
// Created by Aleksander Wedrychowski on 06/10/2022.
// Copyright (c) 2022 Flit Technologies Ltd. All rights reserved.
//

import KarhooSDK

protocol TripStatusNotificationFactory: AnyObject {
    func notification(for tripInfo: TripInfo, withState state: TripState) -> LocalNotification?
}

final class KarhooTripStatusNotificationFactory: TripStatusNotificationFactory {

    func notification(for tripInfo: TripInfo, withState state: TripState) -> LocalNotification? {
        switch state {
        default:
            return LocalNotification(
                title: "State: \(state.rawValue)",
                body: "",
                identifier: tripInfo.tripId
            )
        }
    }
}
