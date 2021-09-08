//
//  KarhooTextInputView.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit

public protocol KarhooInputViewDelegate: AnyObject {
    func didBecomeInactive(identifier: String)
    func didBecomeActive(identifier:String)
}

class KarhooTextInputView: UIView, KarhooInputView {
    
    private var didSetUpConstraints: Bool = false
    
    private var stackContainer: UIStackView!
    private var icon: UIImageView!
    private var iconContainer: UIView!
    private var titleLabel: UILabel!
    private var textView: UITextView!
    private var isOptional: Bool = false
    
    private var iconImage: UIImage?
    private var errorFeedbackType: KarhooTextInputViewErrorFeedbackType = .icon
    private var contentType: KarhooTextInputViewContentType = .firstname
    public weak var delegate: KarhooInputViewDelegate?
    
    init(iconImage: UIImage? = nil,
         errorFeedbackType: KarhooTextInputViewErrorFeedbackType = .text,
         contentType: KarhooTextInputViewContentType = .firstname,
         isOptional: Bool = false,
         accessibilityIdentifier: String) {
        super.init(frame: .zero)
        self.accessibilityIdentifier = accessibilityIdentifier
        self.iconImage = iconImage
        self.errorFeedbackType = errorFeedbackType
        self.contentType = contentType
        self.isOptional = isOptional
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
        
        textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.accessibilityIdentifier = "text_field"
        textView.text = contentType.placeholderText
        textView.font = KarhooUI.fonts.getRegularFont(withSize: 14.0)
        textView.returnKeyType = .done
        textView.textColor = KarhooTextInputViewState.inactive.color
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 3.0
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 5, bottom: 15, right: 5)
        textView.layer.borderColor = KarhooTextInputViewState.inactive.color.cgColor
        textView.autocorrectionType = .no

        switch contentType {
        case .firstname:
            textView.textContentType = .givenName
        case .surname:
            textView.textContentType = .familyName
        case .email:
            textView.keyboardType = .emailAddress
            textView.textContentType = .emailAddress
            textView.autocapitalizationType = .none
        case .phone:
            textView.keyboardType = .phonePad
        case .poiDetails:
            textView.autocapitalizationType = .allCharacters
        default:
            textView.textContentType = .none
        }
        textView.delegate = self
        textView.isScrollEnabled = false
        stackContainer.addArrangedSubview(textView)
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.accessibilityIdentifier = "title_label"
        titleLabel.text = contentType.titleText
        titleLabel.font = KarhooUI.fonts.getRegularFont(withSize: 12.0)
        titleLabel.tintColor = KarhooUI.colors.primaryTextColor
        addSubview(titleLabel)
        
        updateConstraints()
    }
    
    override func updateConstraints() {
        if !didSetUpConstraints {
            
            _ = [icon.widthAnchor.constraint(equalToConstant: 30.0),
                 icon.heightAnchor.constraint(equalToConstant: 30.0),
                 icon.leadingAnchor.constraint(equalTo: iconContainer.leadingAnchor),
                 icon.topAnchor.constraint(equalTo: iconContainer.topAnchor),
                 icon.trailingAnchor.constraint(equalTo: iconContainer.trailingAnchor)].map { $0.isActive = true }
            
            _ = [titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.0),
                 titleLabel.topAnchor.constraint(equalTo: topAnchor)].map { $0.isActive = true }
            
            _ = [stackContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5.0),
                 stackContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
                 stackContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
                 stackContainer.bottomAnchor.constraint(equalTo: bottomAnchor)].map { $0.isActive = true }
            
            didSetUpConstraints = true
        }
        
        super.updateConstraints()
    }
    
    private func tintView(_ state: KarhooTextInputViewState) {
        UIView.animate(withDuration: state == .error ? 0.1 : 0.3) { [weak self] in
            self?.textView.layer.borderColor = state.color.cgColor
            self?.icon.tintColor = state.color
        }
    }
    
    public func resetView() {
        tintView(.inactive)
        textView.text = contentType.placeholderText
    }
    
    public func setActive() {
        textView.becomeFirstResponder()
        delegate?.didBecomeActive(identifier: accessibilityIdentifier!)
    }
    
    public func setInactive() {
        textView.resignFirstResponder()
        delegate?.didBecomeInactive(identifier: accessibilityIdentifier!)
    }

    func dismissKeyboard() {
        textView.resignFirstResponder()
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
            textView.shakeView()
        case .icon:
            icon.shakeView()
        default:
            return
        }
        tintView(.error)
    }
    
    public func isValid() -> Bool {
        if isOptional {
            return true
        } else {
            return validateField()
        }
    }

    func set(text: String? = nil) {
        guard let value = text else {
            return
        }

        textView.text = value
        textView.textColor = KarhooUI.colors.primaryTextColor
    }
    
    private func validateField() -> Bool {
        switch contentType {
        case .email:
            return Utils.isValidEmail(email: textView.text!)
        case .phone:
            return Utils.isValidPhoneNumber(number: textView.text!)
        case .firstname, .surname:
            return textView.text != contentType.placeholderText && Utils.isValidName(name: textView.text)
        default:
            return textView.text != contentType.placeholderText && textView.text != ""
        }
    }
    
    public func isFirstResponder() -> Bool {
        return textView.isFirstResponder
    }

    private func runValidation() {
        switch contentType {
        case .email:
            if !Utils.isValidEmail(email: textView.text!) {
                showError()
            } else {
                textView.resignFirstResponder()
                delegate?.didBecomeInactive(identifier: accessibilityIdentifier!)
            }
        case .phone:
            if !Utils.isValidPhoneNumber(number: textView.text!) {
                showError()
            } else {
                textView.resignFirstResponder()
                delegate?.didBecomeInactive(identifier: accessibilityIdentifier!)
            }
        case .firstname, .surname:
            if validateField() {
                textView.resignFirstResponder()
                delegate?.didBecomeInactive(identifier: accessibilityIdentifier!)
            } else {
                showError()
            }
        default:
            textView.resignFirstResponder()
            delegate?.didBecomeInactive(identifier: accessibilityIdentifier!)
        }
    }
}

extension KarhooTextInputView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        tintView(.active)

        if textView.textColor == KarhooTextInputViewState.inactive.color {
            textView.textColor = KarhooUI.colors.primaryTextColor
            textView.text = nil
        }
        
        delegate?.didBecomeActive(identifier: accessibilityIdentifier!)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        tintView(.inactive)

        if textView.text.contains(" ") && contentType.whitespaceAllowed == false {
            textView.text =  textView.text.trimmingCharacters(in: .whitespaces)
        }

        if textView.text.isEmpty {
            textView.textColor = KarhooTextInputViewState.inactive.color
            textView.text = contentType.placeholderText
        } else {
            runValidation()
            delegate?.didBecomeInactive(identifier: accessibilityIdentifier!)
        }
    }
    
    public func getInput() -> String {
        if textView.text == contentType.placeholderText {
            return ""
        }
        
        return isValid() ? textView.text : ""
    }
    
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        if text == "\n" {
            runValidation()
            return false
        }
        return true
    }
    
    internal func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: frame.width, height: .infinity)
        textView.sizeThatFits(size)
    }
}
