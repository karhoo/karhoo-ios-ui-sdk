//
//  RidePlanning+MVVMC.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 04.04.2023.
//  Copyright © 2023 Flit Technologies Ltd. All rights reserved.
//

import Combine
import Foundation
import KarhooSDK

public protocol RidePlanningCoordinator: KarhooUISDKSceneCoordinator {
}

protocol RidePlanningViewController: BaseViewController {
}

protocol RidePlanningRouter: AnyObject {
    func exitPressed()
    func finished()
}

public struct KarhooRidePlanningResult {
    var journeyDetails: JourneyDetails
    var filters: [QuoteListFilter]?
}

protocol RepresentedMapView {
    var locationPersissionDeniedSubject: PassthroughSubject<Void, Never> { get }
}
