//
//  BookingMap+MVP.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 20.03.2024.
//  Copyright © 2024 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import Combine
import UIKit
import CoreLocation
import KarhooSDK

public protocol BookingMapScreen: BaseViewController {
    func showIncorrectVersionPopup(completion: @escaping () -> Void)
    func openRidesList(presentationStyle: UIModalPresentationStyle?)
    func focusMap()
    
    /// Use these methods in case of presenting the TripAllocationView as an overlay over the BookingMapScreen
    func prepareForAllocation(with trip: TripInfo)
    func resetPrepareForAllocation()
}

extension BookingMapScreen {
    func prepareForAllocation(with trip: TripInfo) {}
    func resetPrepareForAllocation() {}
}

protocol BookingMapView: BaseView {
    func focusMap()
    func prepareForAllocation(location: CLLocation)
    func set(reverseGeolocate: Bool)
    func set(addressBarVisible visible: Bool)
    func set(asapButtonEnabled enabled: Bool)
    func set(prebookButtonEnabled enabled: Bool)
    func set(bottomContainterVisible visible: Bool)
    func set(coverageViewVisible visible: Bool)
    func set(focusButtonVisible visible: Bool)
}

public protocol BookingMapScreenPresenter {
    var hasCoverageInTheAreaPublisher: CurrentValueSubject<Bool?, Never> { get }
    var isAsapEnabledPublisher: CurrentValueSubject<Bool, Never> { get }
    var isScheduleForLaterEnabledPublisher: CurrentValueSubject<Bool, Never> { get }
    
    func load(view: BookingMapScreen?)
    func viewWillAppear()
    func exitPressed()
    func asapRidePressed()
    func prebookRidePressed()
    func showRidesList(presentationStyle: UIModalPresentationStyle?)
}

public struct BookingMapScreenResult {
    public var journeyDetails: JourneyDetails?
}
