//
//  RidesScreenBuilder.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import CoreLocation
import Foundation
import KarhooSDK

public protocol RidesScreenBuilder {
    func buildRidesScreen(completion: @escaping ScreenResultCallback<RidesListAction>) -> Screen
}
