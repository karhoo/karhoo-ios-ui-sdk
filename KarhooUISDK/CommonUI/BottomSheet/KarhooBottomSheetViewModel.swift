//
//  BottomSheetMPV.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 03.11.2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import SwiftUI

protocol BottomSheetViewModel {
    var title: String { get set }
    var cornerRadius: CGFloat { get set }
    var backgroundColor: UIColor { get set }
    var callback: ScreenResultCallback<()>? { get set }
}

class KarhooBottomSheetViewModel: BottomSheetViewModel {
    var title: String = "Some Title"
    var backgroundColor: UIColor = KarhooUI.colors.white
    var cornerRadius: CGFloat = UIConstants.CornerRadius.xLarge
    var callback: ScreenResultCallback<()>?
}
