//
//  JourneyDetailsManager.swift
//  KarhooSDK
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import Foundation
import KarhooSDK

public protocol JourneyDetailsObserver: AnyObject {
    func journeyDetailsChanged(details: JourneyDetails?)
}

public protocol JourneyDetailsManager {
    func add(observer: JourneyDetailsObserver)
    func remove(observer: JourneyDetailsObserver)

    func set(pickup: LocationInfo?)
    func set(destination: LocationInfo?)
    func set(prebookDate: Date?)
    func reset(with journeyDetails: JourneyDetails)
    func silentReset(with journeyDetails: JourneyDetails)
    func reset()
    func setJourneyInfo(journeyInfo: JourneyInfo?)
    func getJourneyDetails() -> JourneyDetails?
}
