//
//  KarhooInputView.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit

protocol KarhooInputView: UIView {
    func resetView()
    func setActive()
    func setInactive()
    func showIcon(_ show: Bool)
    func showError()
    func getIntput() -> String
    func isValid() -> Bool
    func isFirstResponder() -> Bool
    func set(text: String?)
    func dismissKeyboard()
}
