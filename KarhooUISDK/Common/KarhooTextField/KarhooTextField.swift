//
//  KarhooTextField.swift
//  KarhooUI
//
//
//  Copyright © 2017 Airla Tech Ltd. All rights reserved.
//

import UIKit

public protocol Validator {
    func validate(text: String)
    func set(listener: ValidatorListener?)
}

public protocol ValidatorListener: class {
    func valid()
    func invalid(reason: String?)
}

public protocol PhoneNumberValidatorProtocol: Validator {
    func set(countryCode: String)
}

public protocol KarhooTextFieldStateDelegate: class {
    func didChange(text: String, isValid: Bool, identifier: Int)
}

public protocol KarhooTextFieldEvents: class {
    func fieldDidFocus(identifier: Int)
    func fieldDidUnFocus(identifier: Int)
}

public final class KarhooTextField: NibLoadableView, ValidatorListener {

    public weak var stateDelegate: KarhooTextFieldStateDelegate?
    public weak var fieldEventsDelegate: KarhooTextFieldEvents?

    public var characterLimit: Int = Int.max
    @IBOutlet public weak var placeholderLabel: UILabel?
    @IBOutlet public weak var inputField: UITextField?
    @IBOutlet public var resizingSwitcher: ResizingSwitcher?
    @IBOutlet public var errorBorders: [UIView]?
    @IBOutlet public weak var invalidIcon: UIImageView?
    @IBOutlet public weak var validIcon: UIImageView?

    public var validator: Validator?
    public var fieldIdentity: Int?
    public var initialPlaceholder: String?
    public var isValid: Bool = false
    public func set(validator: Validator) {
        self.validator = validator
        self.validator?.set(listener: self)
    }

    public func set(animationTime: Double) {
        resizingSwitcher?.set(animationTime: animationTime)
    }

    public func set(characterLimit: Int) {
        self.characterLimit = characterLimit
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        inputField?.layer.sublayerTransform = CATransform3DMakeTranslation(15, 10, 0)
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        setDefaultState()
        inputField?.delegate = self
    }

    public func set(stateDelegate: KarhooTextFieldStateDelegate?) {
        self.stateDelegate = stateDelegate
    }

    public func set(fieldEventsDelegate: KarhooTextFieldEvents?) {
        self.fieldEventsDelegate = fieldEventsDelegate
    }

    public func set(identifier: Int) {
        self.fieldIdentity = identifier
    }

    public func set(defaultPlaceholder: String?) {
        initialPlaceholder = defaultPlaceholder
        placeholderLabel?.text = defaultPlaceholder
    }

    public func set(text: String) {
        inputField?.text = text
        if text.isEmpty {
            resizingSwitcher?.expand()
        } else {
            resizingSwitcher?.contract()
        }
    }
    
    var text: String? {
        return inputField?.text
    }

    public func set(secureText: Bool) {
        guard let input = inputField else { return }
        input.isSecureTextEntry = secureText

        //Workaround to refresh the position of the cursor as the secureTextEntry toggle misplaces it
        let beginning = input.beginningOfDocument
        let end = input.endOfDocument
        input.selectedTextRange = input.textRange(from: beginning, to: beginning)
        input.selectedTextRange = input.textRange(from: end, to: end)
    }

    public func setDefaultState() {
        invalidIcon?.alpha = 0
        validIcon?.alpha = 0
        setValue(0.0, forKeyPath: "errorBorders.alpha")
        placeholderLabel?.text = initialPlaceholder
        placeholderLabel?.textColor = KarhooUI.colors.medGrey
    }

    public func setFocus() {
        inputField?.becomeFirstResponder()
    }

    public func setUnFocus() {
        inputField?.resignFirstResponder()
    }

    public func set(autoCapitalisationType: UITextAutocapitalizationType) {
        inputField?.autocapitalizationType = autoCapitalisationType
    }

    public func set(keyboardType: UIKeyboardType) {
        inputField?.keyboardType = keyboardType
    }

    public func set(enabled: Bool) {
       inputField?.isEnabled = enabled
    }

    var isExpanded: Bool {
        guard let resizingSwitcher = self.resizingSwitcher else { return false }
        return resizingSwitcher.isExpanded()
    }

    public func setExpanded(_ expand: Bool, animated: Bool) {
        guard let resizingSwitcher = self.resizingSwitcher else { return }

        if expand {
            resizingSwitcher.expand(animated: animated)
        } else {
            resizingSwitcher.contract(animated: animated)
        }
    }

    public func valid() {
        isValid = true
        placeholderLabel?.textColor = KarhooUI.colors.medGrey
        inputField?.textColor = KarhooUI.colors.darkGrey
        setValue(0.0, forKeyPath: "errorBorders.alpha")
        placeholderLabel?.text = initialPlaceholder
        invalidIcon?.alpha = 0
        validIcon?.alpha = 1
    }

    public func invalid(reason: String?) {
        isValid = false
        placeholderLabel?.textColor = KarhooUI.colors.darkGrey
        setValue(1.0, forKeyPath: "errorBorders.alpha")
        invalidIcon?.alpha = 1
        validIcon?.alpha = 0
        if reason?.isEmpty == false {
            placeholderLabel?.text = reason
        }
    }

    public func runValidator() {
        if let validator = validator {
            validator.validate(text: inputField?.text ?? "")
        } else {
            isValid = inputField?.text?.isEmpty == false
        }
    }

    @IBAction private func onFocus() {
        resizingSwitcher?.contract()

        guard let identifier = self.fieldIdentity else {
            return
        }

        fieldEventsDelegate?.fieldDidFocus(identifier: identifier)
    }

    @IBAction private func onUnFocus() {
        if inputField?.text?.isEmpty == true {
            resizingSwitcher?.expand()
        } else {
            runValidator()
        }

        guard let identifier = self.fieldIdentity else {
            return
        }

        fieldEventsDelegate?.fieldDidUnFocus(identifier: identifier)
    }

    @IBAction private func changedText() {
        runValidator()
        setDefaultState()
        if let identity = fieldIdentity {
            stateDelegate?.didChange(text: inputField?.text ?? "", isValid: isValid, identifier: identity)
        }
    }
}

extension KarhooTextField: UITextFieldDelegate {

    public func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let textFieldText = textField.text else {
            return true
        }

        let newLength = textFieldText.count + string.count - range.length
        return newLength <= self.characterLimit
    }
}
