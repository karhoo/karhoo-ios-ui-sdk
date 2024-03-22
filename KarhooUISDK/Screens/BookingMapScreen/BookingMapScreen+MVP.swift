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

public protocol BookingMapScreen: BaseViewController {
    func showIncorrectVersionPopup(completion: @escaping () -> Void)
    func openRidesList(presentationStyle: UIModalPresentationStyle?)
    func focusMap()
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
