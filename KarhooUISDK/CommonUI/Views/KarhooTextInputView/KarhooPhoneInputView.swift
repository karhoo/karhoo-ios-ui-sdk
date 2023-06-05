//
//  KarhooPhoneInputView.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import PhoneNumberKit

struct KHPhoneInputViewIdentifiers {
    static let containerStackView = "container_stack_view"
    static let contentStackView = "content_stack_view"
    static let iconContainerView = "icon_container_view"
    static let iconImageView = "icon_image_view"
    static let titleLabel = "title_label"
    static let textView = "text_view"
    static let countryCodeButton = "country_code_button"
    static let errorLabel = "error_label"
}

class KarhooPhoneInputView: UIView {
    
    // MARK: - Variables and Controls
    public weak var delegate: KarhooInputViewDelegate?
    
    private var didSetUpConstraints: Bool = false
    private var iconImage: UIImage?
    private var errorFeedbackType: KarhooTextInputViewErrorFeedbackType = .icon
    private let shouldFocusNumberInputAutomatically: Bool
    
    private var country: Country = KarhooCountryParser.defaultCountry {
        didSet {
            countryCodeButton.setTitle(country.phoneCode, for: .normal)
            countryCodeButton.setImage(UIImage.uisdkImage(country.code), for: .normal)
        }
    }
    
    private let contentType: KarhooTextInputViewContentType = .phone
    private let countryCodeButtonWidth: CGFloat = 120.0
    private let iconSize: CGFloat = 30.0
    private let padding: CGFloat = 15.0
    private let innerSpacing: CGFloat = 5.0
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.accessibilityIdentifier = KHPhoneInputViewIdentifiers.containerStackView
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = innerSpacing
        return stackView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.accessibilityIdentifier = KHPhoneInputViewIdentifiers.contentStackView
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = innerSpacing
        return stackView
    }()
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(image: iconImage?.withRenderingMode(.alwaysTemplate))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.accessibilityIdentifier = KHPhoneInputViewIdentifiers.iconImageView
        imageView.tintColor = KarhooTextInputViewState.inactive.color
        imageView.contentMode = .scaleAspectFit
        imageView.anchor(width: iconSize, height: iconSize)
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = KHPhoneInputViewIdentifiers.titleLabel
        label.text = contentType.titleText
        label.font = KarhooUI.fonts.getRegularFont(withSize: 12.0)
        label.textColor = KarhooUI.colors.text
        return label
    }()
    
    private lazy var countryCodeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = KHPhoneInputViewIdentifiers.countryCodeButton
        button.layer.borderColor = KarhooTextInputViewState.inactive.color.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 3.0
        button.setTitle(KarhooCountryParser.defaultCountry.phoneCode, for: .normal)
        button.titleLabel?.font = KarhooUI.fonts.getRegularFont(withSize: 14.0)
        button.setTitleColor(KarhooUI.colors.primaryTextColor, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: padding, left: 0, bottom: padding, right: innerSpacing)
        button.setImage(UIImage.uisdkImage(KarhooCountryParser.defaultCountry.code), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: padding, left: -padding, bottom: padding, right: innerSpacing)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(countryCodeSelected), for: .touchUpInside)
        button.anchor(width: countryCodeButtonWidth)
        return button
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.accessibilityIdentifier = KHPhoneInputViewIdentifiers.textView
        textView.text = contentType.placeholderText
        textView.font = KarhooUI.fonts.getRegularFont(withSize: 14.0)
        textView.returnKeyType = .done
        textView.textColor = KarhooTextInputViewState.inactive.color
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 3.0
        textView.textContainerInset = UIEdgeInsets(top: padding, left: innerSpacing, bottom: padding, right: innerSpacing)
        textView.layer.borderColor = KarhooTextInputViewState.inactive.color.cgColor
        textView.autocorrectionType = .no
        textView.keyboardType = .phonePad
        textView.delegate = self
        textView.isScrollEnabled = false
        return textView
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = KHPhoneInputViewIdentifiers.errorLabel
        label.text = UITexts.Errors.missingPhoneNumber
        label.textColor = UIColor.red
        label.font = KarhooUI.fonts.captionRegular()
        return label
    }()
    
    // MARK: - Init
    init(iconImage: UIImage? = nil,
         errorFeedbackType: KarhooTextInputViewErrorFeedbackType = .text,
         accessibilityIdentifier: String,
         shouldFocusNumberInputAutomatically: Bool) {
        self.shouldFocusNumberInputAutomatically = shouldFocusNumberInputAutomatically
        super.init(frame: .zero)
        self.accessibilityIdentifier = accessibilityIdentifier
        self.iconImage = iconImage
        self.errorFeedbackType = errorFeedbackType
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(contentStackView)
        containerStackView.addArrangedSubview(errorLabel)
        
        errorLabel.isHidden = true
        
        contentStackView.addArrangedSubview(iconImageView)
        contentStackView.addArrangedSubview(countryCodeButton)
        contentStackView.addArrangedSubview(textView)
        
        iconImageView.isHidden = iconImage == nil
    }
    
    override func updateConstraints() {
        if !didSetUpConstraints {
            containerStackView.anchor(top: topAnchor,
                                      leading: leadingAnchor,
                                      trailing: trailingAnchor,
                                      bottom: bottomAnchor)
            
            countryCodeButton.topAnchor.constraint(equalTo: textView.topAnchor).isActive = true
            countryCodeButton.bottomAnchor.constraint(equalTo: textView.bottomAnchor).isActive = true
            didSetUpConstraints = true
        }
        
        super.updateConstraints()
    }
    
    // MARK: - Actions
    @objc private func countryCodeSelected() {
        tintView(.active)
        
        let presenter = CountryCodeSelectionPresenter(preSelectedCountry: country) { [weak self] result in
            guard let value = result.completedValue()
            else {
                self?.focusPhoneNumberField()
                return
            }

            self?.country = value
            self?.runValidation()
            self?.focusPhoneNumberField()
        }

        let vc = CountryCodeSelectionViewController(presenter: presenter)
        if let topController = ViewControllerUtils.topBaseViewController {
            topController.showAsOverlay(item: vc, animated: true)
        }
    }
    
    private func focusPhoneNumberField() {
        guard shouldFocusNumberInputAutomatically else { return }
        textView.becomeFirstResponder()
    }
    
    // MARK: - Utils
    private func tintView(_ state: KarhooTextInputViewState) {
       UIView.animate(withDuration: state == .error ? 0.1 : 0.3) { [weak self] in
        self?.textView.layer.borderColor = state.color.cgColor
        self?.iconImageView.tintColor = state.color
       }
   }
    
    private func validatePhoneNumber() -> Bool {
        let phoneNumber = country.phoneCode + textView.text
        let phoneNumberKit = PhoneNumberKit()
        do {
            _ = try phoneNumberKit.parse(phoneNumber)
            return true
        } catch {
//            print("Generic parser error")
            return false
        }
    }
    
    private func runValidation() {
        if !Utils.isValidPhoneNumber(number: getInput()) {
            showError()
        } else {
            errorLabel.isHidden = true
            textView.resignFirstResponder()
            delegate?.didBecomeInactive(identifier: accessibilityIdentifier!)
        }
    }
}
 
extension KarhooPhoneInputView: KarhooPhoneInputViewProtocol {
    public func resetView() {
        tintView(.inactive)
        textView.text = nil
    }
    
    public func setActive() {
        textView.becomeFirstResponder()
    }

    public func setInactive() {
        textView.resignFirstResponder()
    }
    
    public func showIcon(_ show: Bool) {
        iconImageView.isHidden = !show
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
            iconImageView.shakeView()
        default:
            return
        }
        tintView(.error)
        
        if textView.text == nil || (textView.text?.isEmpty ?? true) {
            errorLabel.text = UITexts.Errors.missingPhoneNumber
        } else {
            errorLabel.text = UITexts.Errors.invalidPhoneNumber
        }
        errorLabel.isHidden = false
    }

    public func getInput() -> String {
        _ = validatePhoneNumber()
        return country.phoneCode + textView.text
    }
    
    public func isValid() -> Bool {
        return validatePhoneNumber()
    }

    public func isFirstResponder() -> Bool {
        return textView.isFirstResponder
    }
    
    func set(text: String? = nil) {
        guard var value = text else {
            return
        }
        
        if value.hasPrefix("+") {
            // The phone code in the phone number coincides with the provided country's phone code
            if value.hasPrefix(country.phoneCode) {
                value = value.removePrefix(country.phoneCode)
            }
            // The phone number provided has a different phone code than the provided country's phone code
            else {
                let allCountries = KarhooCountryParser.getCountries().sorted(by: { $0.code < $1.code })
                if let newCountry = allCountries.first(where: { value.starts(with: $0.phoneCode) }) {
                    country = newCountry
                    value = value.removePrefix(country.phoneCode)
                }
            }
        }
        
        textView.text = value
        textView.textColor = KarhooUI.colors.text
    }
    
    func setBackgroundColor(_ color: UIColor) {
        textView.backgroundColor = color
    }

    func dismissKeyboard() {
        textView.resignFirstResponder()
    }
    
    public func getFullPhoneNumber() -> String {
       return getInput()
   }

   public func getPhoneNumberNoCountryCode() -> String {
        return textView.text
   }

   public func getCountryCode() -> String {
        return country.code
   }
    
    public func set(country: Country) {
        self.country = country
    }
}

extension KarhooPhoneInputView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        tintView(.active)
        if textView.textColor == KarhooTextInputViewState.inactive.color {
            textView.textColor = KarhooUI.colors.text
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
        }
        
        runValidation()
        delegate?.didBecomeInactive(identifier: accessibilityIdentifier!)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
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
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: frame.width, height: .infinity)
        textView.sizeThatFits(size)
        delegate?.didChangeCharacterInSet(identifier: accessibilityIdentifier!)
    }
}
