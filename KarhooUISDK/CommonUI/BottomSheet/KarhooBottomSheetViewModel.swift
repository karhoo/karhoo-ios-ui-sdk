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
    var shouldPresent: Bool { get set }
    var child: AnyView { get set }
    var callback: ScreenResultCallback<()>? { get set }
    
    func present()
    func dismiss()
}

class KarhooBottomSheetViewModel: BottomSheetViewModel {
    var title: String = "Some Title"
    var backgroundColor: UIColor = KarhooUI.colors.white
    var cornerRadius: CGFloat = UIConstants.CornerRadius.xLarge
    var shouldPresent: Bool = false
    var child: AnyView = AnyView(Color.yellow)
    var callback: ScreenResultCallback<()>?
    
    func present() {
        shouldPresent = true
    }
    
    func dismiss() {
        shouldPresent = false
    }
    
    
}
