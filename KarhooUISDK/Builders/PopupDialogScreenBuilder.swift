//
//  PopupDialogScreenBuilder.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import CoreLocation
import Foundation
import KarhooSDK

protocol PopupDialogScreenBuilder {
    func buildPopupDialogScreen(callback: @escaping ScreenResultCallback<Void>) -> Screen
}
