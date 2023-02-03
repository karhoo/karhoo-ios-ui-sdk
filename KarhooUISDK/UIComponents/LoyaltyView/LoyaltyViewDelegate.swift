//
//  KarhooLoyaltyViewMVP.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 16.11.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK
import UIKit

public protocol LoyaltyViewDelegate: AnyObject {
    func didChangeMode(newValue: LoyaltyMode)
    func didStartLoading()
    func didEndLoading()
}
