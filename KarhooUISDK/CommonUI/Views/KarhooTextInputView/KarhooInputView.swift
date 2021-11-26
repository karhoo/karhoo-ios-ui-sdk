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
    func getInput() -> String
    func isValid() -> Bool
    func isFirstResponder() -> Bool
    func set(text: String?)
    func dismissKeyboard()
}

protocol KarhooPhoneInputViewProtocol: KarhooInputView {
    func getFullPhoneNumber() -> String
    func getCountryCode() -> String
    func getPhoneNumberNoCountryCode() -> String
    
    // NOTE: When using KarhooPhoneInputView set the country before the text for best results
    // This is not mandatory, as the usage may vary from component to component
    func set(country: Country)
}
