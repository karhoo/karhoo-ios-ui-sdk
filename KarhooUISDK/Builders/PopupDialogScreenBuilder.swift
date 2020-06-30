//
//  PopupDialogBuilder.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
import CoreLocation

internal protocol PopupDialogScreenBuilder {
    func buildPopupDialogScreen(callback: @escaping ScreenResultCallback<Void>) -> Screen
}
