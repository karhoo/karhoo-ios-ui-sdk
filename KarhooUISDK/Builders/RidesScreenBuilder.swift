//
//  RidesScreenBuilder.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
import CoreLocation

public protocol RidesScreenBuilder {
    func buildRidesScreen(completion: @escaping ScreenResultCallback<RidesListAction>) -> Screen
}
