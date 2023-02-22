//
//  KarhooDeprecatedTextField.swift
//  KarhooUI
//
//
//  Copyright © 2017 Airla Tech Ltd. All rights reserved.
//

import UIKit

protocol Validator {
    func validate(text: String)
    func set(listener: ValidatorListener?)
}

protocol ValidatorListener: AnyObject {
    func valid()
    func invalid(reason: String?)
}

protocol PhoneNumberValidatorProtocol: Validator {
    func set(countryCode: String)
}

protocol KarhooDeprecatedTextFieldStateDelegate: AnyObject {
    func didChange(text: String, isValid: Bool, identifier: Int)
}

protocol KarhooDeprecatedTextFieldEvents: AnyObject {
    func fieldDidFocus(identifier: Int)
    func fieldDidUnFocus(identifier: Int)
}

final class KarhooDeprecatedTextField: NibLoadableView, ValidatorListener {

    private weak var stateDelegate: KarhooDeprecatedTextFieldStateDelegate?
    private weak var fieldEventsDelegate: KarhooDeprecatedTextFieldEvents?

    private var characterLimit: Int = Int.max
    @IBOutlet private weak var placeholderLabel: UILabel?
    @IBOutlet private weak var inputField: UITextField?
    @IBOutlet private var resizingSwitcher: ResizingSwitcher?
    @IBOutlet private var errorBorders: [UIView]?
    @IBOutlet private weak var invalidIcon: UIImageView?
    @IBOutlet private weak var validIcon: UIImageView?

    private var validator: Validator?
    private var fieldIdentity: Int?
    private var initialPlaceholder: String?
    private var isValid: Bool = false
    func set(validator: Validator) {
        self.validator = validator
        self.validator?.set(listener: self)
    }

    func set(animationTime: Double) {
        resizingSwitcher?.set(animationTime: animationTime)
    }

    func set(characterLimit: Int) {
        self.characterLimit = characterLimit
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        inputField?.layer.sublayerTransform = CATransform3DMakeTranslation(15, 10, 0)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setDefaultState()
        inputField?.delegate = self
    }

    func set(stateDelegate: KarhooDeprecatedTextFieldStateDelegate?) {
        self.stateDelegate = stateDelegate
    }

    func set(fieldEventsDelegate: KarhooDeprecatedTextFieldEvents?) {
        self.fieldEventsDelegate = fieldEventsDelegate
    }

    func set(identifier: Int) {
        self.fieldIdentity = identifier
    }

    func set(defaultPlaceholder: String?) {
        initialPlaceholder = defaultPlaceholder
        placeholderLabel?.text = defaultPlaceholder
    }

    func set(text: String) {
        inputField?.text = text
        if text.isEmpty {
            resizingSwitcher?.expand()
        } else {
            resizingSwitcher?.contract()
        }
    }

    func set(secureText: Bool) {
        guard let input = inputField else { return }
        input.isSecureTextEntry = secureText

        // Workaround to refresh the position of the cursor as the secureTextEntry toggle misplaces it
        let beginning = input.beginningOfDocument
        let end = input.endOfDocument
        input.selectedTextRange = input.textRange(from: beginning, to: beginning)
        input.selectedTextRange = input.textRange(from: end, to: end)
    }

    func setDefaultState() {
        invalidIcon?.alpha = 0
        validIcon?.alpha = 0
        setValue(0.0, forKeyPath: "errorBorders.alpha")
        placeholderLabel?.text = initialPlaceholder
        placeholderLabel?.textColor = KarhooUI.colors.medGrey
    }

    func setFocus() {
        inputField?.becomeFirstResponder()
    }

    func setUnFocus() {
        inputField?.resignFirstResponder()
    }

    func set(autoCapitalisationType: UITextAutocapitalizationType) {
        inputField?.autocapitalizationType = autoCapitalisationType
    }

    func set(keyboardType: UIKeyboardType) {
        inputField?.keyboardType = keyboardType
    }

    func set(enabled: Bool) {
       inputField?.isEnabled = enabled
    }

    var isExpanded: Bool {
        guard let resizingSwitcher = self.resizingSwitcher else { return false }
        return resizingSwitcher.isExpanded()
    }

    func setExpanded(_ expand: Bool, animated: Bool) {
        guard let resizingSwitcher = self.resizingSwitcher else { return }

        if expand {
            resizingSwitcher.expand(animated: animated)
        } else {
            resizingSwitcher.contract(animated: animated)
        }
    }

    func valid() {
        isValid = true
        placeholderLabel?.textColor = KarhooUI.colors.medGrey
        inputField?.textColor = KarhooUI.colors.darkGrey
        setValue(0.0, forKeyPath: "errorBorders.alpha")
        placeholderLabel?.text = initialPlaceholder
        invalidIcon?.alpha = 0
        validIcon?.alpha = 1
    }

    func invalid(reason: String?) {
        isValid = false
        placeholderLabel?.textColor = KarhooUI.colors.darkGrey
        setValue(1.0, forKeyPath: "errorBorders.alpha")
        invalidIcon?.alpha = 1
        validIcon?.alpha = 0
        if reason?.isEmpty == false {
            placeholderLabel?.text = reason
        }
    }

    func runValidator() {
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

extension KarhooDeprecatedTextField: UITextFieldDelegate {

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let textFieldText = textField.text else {
            return true
        }

        let newLength = textFieldText.count + string.count - range.length
        return newLength <= self.characterLimit
    }
}
