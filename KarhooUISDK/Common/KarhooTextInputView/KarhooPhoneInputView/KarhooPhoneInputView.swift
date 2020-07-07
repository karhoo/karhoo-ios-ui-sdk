//
//  KarhooPhoneInputView.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import PhoneNumberKit

class KarhooPhoneInputView: UIView, KarhooInputView {
    
    private var didSetUpConstraints: Bool = false
    
    private var stackContainer: UIStackView!
    private var icon: UIImageView!
    private var iconContainer: UIView!
    private var placeholder: UILabel!
    private var placeholderTopConstraint: NSLayoutConstraint!
    private var textField: UITextView!
    private var countryCode: UIButton!
    private var separatorLine: LineView!
    private var lineView: LineView!
    
    private var iconImage: UIImage?
    private var placeholderText: String = "Phone Number"
    private var errorFeedbackType: KarhooTextInputViewErrorFeedbackType = .icon
    private var phoneNumber: String = ""
    public weak var delegate: KarhooInputViewDelegate?
    
    private var dataSource: PhoneCountryCodeDataSource!
    
    init(iconImage: UIImage? = nil,
         errorFeedbackType: KarhooTextInputViewErrorFeedbackType = .text,
         accessibilityIdentifier: String,
         dataSource: PhoneCountryCodeDataSource = KarhooPhoneCountryCodeDataSource()) {
        super.init(frame: .zero)
        self.accessibilityIdentifier = accessibilityIdentifier
        self.iconImage = iconImage
        self.errorFeedbackType = errorFeedbackType
        self.dataSource = dataSource
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        stackContainer = UIStackView()
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        stackContainer.accessibilityIdentifier = "stack_container"
        stackContainer.axis = .horizontal
        stackContainer.spacing = 5.0
        addSubview(stackContainer)
        
        iconContainer = UIView()
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.accessibilityIdentifier = "icon_container_view"
        iconContainer.isHidden = iconImage != nil ? false : true
        stackContainer.addArrangedSubview(iconContainer)
        
        icon = UIImageView(image: iconImage?.withRenderingMode(.alwaysTemplate))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.accessibilityIdentifier = "icon_image"
        icon.tintColor = KarhooTextInputViewState.inactive.color
        icon.contentMode = .scaleAspectFit
        iconContainer.addSubview(icon)
        
        countryCode = UIButton(type: .custom)
        countryCode.translatesAutoresizingMaskIntoConstraints = false
        countryCode.accessibilityIdentifier = "country_code_label"
        countryCode.setTitle("+00", for: .normal)
        countryCode.setTitleColor(KarhooTextInputViewState.inactive.color, for: .normal)
        countryCode.titleEdgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        countryCode.titleLabel?.font = KarhooUI.fonts.bodyRegular()
        countryCode.addTarget(self, action: #selector(countryCodeTapped), for: .touchUpInside)
        stackContainer.addArrangedSubview(countryCode)
        
        separatorLine = LineView(color: KarhooTextInputViewState.inactive.color,
                                 width: 1.0,
                                 accessibilityIdentifier: "line_view")
        stackContainer.addArrangedSubview(separatorLine)
        
        textField = UITextView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.accessibilityIdentifier = "text_field"
        textField.text = placeholderText
        textField.font = KarhooUI.fonts.bodyRegular()
        textField.returnKeyType = .done
        textField.textColor = KarhooTextInputViewState.inactive.color
        textField.delegate = self
        textField.isScrollEnabled = false
        stackContainer.addArrangedSubview(textField)
        
        placeholder = UILabel()
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        placeholder.accessibilityIdentifier = "placeholder_label"
        placeholder.text = textField.text
        placeholder.font = textField.font?.withSize(textField.font!.pointSize / 2)
        placeholder.textColor = KarhooTextInputViewState.inactive.color
        placeholder.alpha = 0
        addSubview(placeholder)
        
        lineView = LineView(color: KarhooTextInputViewState.inactive.color,
                            accessibilityIdentifier: "line_view")
        addSubview(lineView)
        
        updateConstraints()
    }
    
    override func updateConstraints() {
        if !didSetUpConstraints {
            
            _ = [icon.widthAnchor.constraint(equalToConstant: 30.0),
                 icon.heightAnchor.constraint(equalToConstant: 30.0),
                 icon.leadingAnchor.constraint(equalTo: iconContainer.leadingAnchor),
                 icon.topAnchor.constraint(equalTo: iconContainer.topAnchor),
                 icon.trailingAnchor.constraint(equalTo: iconContainer.trailingAnchor)].map { $0.isActive = true }
            
            _ = [stackContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
                 stackContainer.topAnchor.constraint(equalTo: topAnchor, constant: 13.0),
                 stackContainer.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                          constant: -10.0)].map { $0.isActive = true }
            
            _ = [countryCode.heightAnchor.constraint(equalToConstant: 30.0),
                 countryCode.widthAnchor.constraint(equalToConstant: 50.0)].map { $0.isActive = true }
            
            _ = [separatorLine.topAnchor.constraint(equalTo: stackContainer.topAnchor),
                 separatorLine.bottomAnchor.constraint(equalTo: stackContainer.bottomAnchor)].map { $0.isActive = true }
            
            textField.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
            
            placeholder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.0).isActive = true
            placeholderTopConstraint = placeholder.topAnchor.constraint(equalTo: topAnchor, constant: 15.0)
            placeholderTopConstraint.isActive = true
            
            _ = [lineView.topAnchor.constraint(equalTo: stackContainer.bottomAnchor),
                 lineView.leadingAnchor.constraint(equalTo: leadingAnchor),
                 lineView.trailingAnchor.constraint(equalTo: trailingAnchor),
                 lineView.bottomAnchor.constraint(equalTo: bottomAnchor),
                 lineView.heightAnchor.constraint(equalToConstant: 1.0)].map { $0.isActive = true }
            
            didSetUpConstraints = true
        }
        
        super.updateConstraints()
    }
    
    private func tintView(_ state: KarhooTextInputViewState) {
        UIView.animate(withDuration: state == .error ? 0.1 : 0.3) { [weak self] in
            self?.lineView.backgroundColor = state.color
            self?.icon.tintColor = state.color
            self?.placeholder.textColor = state.color
            self?.separatorLine.backgroundColor = state.color
        }
    }
    
    private func animatePlaceHoder(show: Bool) {
        placeholderTopConstraint.constant = show ? 0.0 : 15.0
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.layoutIfNeeded()
            self?.placeholder.alpha = show ? 1.0 : 0.0
        }
    }

    func set(text: String? = nil) {
        guard let value = text else {
            return
        }
        textField.text = value
    }

    func dismissKeyboard() {
        textField.resignFirstResponder()
    }
    
    @objc
    private func countryCodeTapped() {
        tintView(.active)
        showCountryPicker()
    }
    
    public func resetView() {
        animatePlaceHoder(show: false)
        tintView(.inactive)
        textField.text = placeholderText
    }
    
    public func setActive() {
        textField.becomeFirstResponder()
    }
    
    public func setInactive() {
        textField.resignFirstResponder()
    }
    
    public func showIcon(_ show: Bool) {
        iconContainer.isHidden = !show
    }
    
    public func showError() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
        
        switch errorFeedbackType {
        case .full:
            shakeView()
        case .text:
            textField.shakeView()
        case .icon:
            icon.shakeView()
        default:
            return
        }
        tintView(.error)
    }
    
    public func getIntput() -> String {
        _ = validatePhoneNumber()
        return phoneNumber
    }
    
    private func showCountryPicker() {
        let alertView = UIAlertController(
            title: UITexts.User.countryCode,
            message: "\n\n\n\n\n\n\n\n\n",
            preferredStyle: .alert)
        
        let pickerView = UIPickerView(frame:
            CGRect(x: 0, y: 50, width: 260, height: 162))
        pickerView.dataSource = self
        pickerView.delegate = self
        
        alertView.view.addSubview(pickerView)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertView.addAction(action)
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            topController.present(alertView, animated: true) {
                pickerView.frame.size.width = alertView.view.frame.size.width
            }
        }
    }
    
    private func validatePhoneNumber() -> Bool {
        phoneNumber = (countryCode.titleLabel?.text)! + textField.text
        let phoneNumberKit = PhoneNumberKit()
        do {
            _ = try phoneNumberKit.parse(phoneNumber)
            return true
        } catch {
            print("Generic parser error")
            return false
        }
    }
    
    public func isValid() -> Bool {
        return countryCode.titleLabel?.text != "+00" && (textField.text != placeholderText || textField.text != "")
    }
    
    public func isFirstResponder() -> Bool {
        return textField.isFirstResponder
    }
}

extension KarhooPhoneInputView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let newPosition = textField.beginningOfDocument
        textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
        tintView(.active)
        if textView.textColor == KarhooUI.colors.lightGrey {
            textView.textColor = KarhooUI.colors.darkGrey
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        tintView(.inactive)
    }
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        if text == "\n" {
            if !validatePhoneNumber() {
                showError()
            } else {
                textView.resignFirstResponder()
                delegate?.didBecomeInactive(identifier: accessibilityIdentifier!)
            }
            return false
        }
        return true
    }
    
    internal func textViewDidChange(_ textView: UITextView) {
        tintView(.active)
        if textView.text.contains(placeholderText) {
            animatePlaceHoder(show: true)
            textView.text = textView.text.replacingOccurrences(of: placeholderText, with: "")
            textView.textColor = KarhooUI.colors.darkGrey
        }
        
        if textView.text?.count == 0 {
            textView.text = placeholderText
            textView.textColor = KarhooUI.colors.lightGrey
            animatePlaceHoder(show: false)
        }
        
        let size = CGSize(width: frame.width, height: .infinity)
        textView.sizeThatFits(size)
    }
}

extension KarhooPhoneInputView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.rowCount
    }
}

extension KarhooPhoneInputView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countryCode.setTitle(dataSource.countryCode(at: row), for: .normal)
        countryCode.setTitleColor(KarhooUI.colors.darkGrey, for: .normal)
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    viewForRow row: Int,
                    forComponent component: Int,
                    reusing view: UIView?) -> UIView {
        
        pickerView.backgroundColor = .groupTableViewBackground
        var label = view as? UILabel
        if label == nil {
            label = UILabel()
            label?.font = UIFont.systemFont(ofSize: 15)
            label?.textAlignment = .center
        }
        
        label?.text = dataSource?.titleForRow(at: row)
        
        return label!
    }
}
