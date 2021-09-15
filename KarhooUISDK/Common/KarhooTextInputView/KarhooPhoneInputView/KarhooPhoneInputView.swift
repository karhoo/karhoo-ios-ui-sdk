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
    static let iconContainerView = "icon_container_view"
    static let iconImageView = "icon_image_view"
    static let titleLabel = "title_label"
    static let countryCodeButton = "country_code_button"
}

class KarhooPhoneInputView: UIView {
    
    // MARK: - Variables and Controls
    public weak var delegate: KarhooInputViewDelegate?
    
    private var didSetUpConstraints: Bool = false
    private var iconImage: UIImage?
    private var errorFeedbackType: KarhooTextInputViewErrorFeedbackType = .icon
    
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
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 5.0
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
        label.tintColor = KarhooUI.colors.primaryTextColor
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
        button.setImage(UIImage.uisdkImage(KarhooCountryParser.defaultCountry.code).withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: padding, left: -padding, bottom: padding, right: innerSpacing)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(countryCodeSelected), for: .touchUpInside)
        button.anchor(width: countryCodeButtonWidth)
        return button
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.accessibilityIdentifier = "text_field"
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
    
    // MARK: - Init
    init(iconImage: UIImage? = nil,
         errorFeedbackType: KarhooTextInputViewErrorFeedbackType = .text,
         accessibilityIdentifier: String) {
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
        addSubview(titleLabel)
        addSubview(containerStackView)
        
        containerStackView.addArrangedSubview(iconImageView)
        containerStackView.addArrangedSubview(countryCodeButton)
        containerStackView.addArrangedSubview(textView)
        
        iconImageView.isHidden = iconImage == nil
    }
    
    override func updateConstraints() {
        if !didSetUpConstraints {
            
            titleLabel.anchor(top: topAnchor,
                              leading: leadingAnchor)
            
            containerStackView.anchor(top: titleLabel.bottomAnchor,
                                      leading: leadingAnchor,
                                      bottom: bottomAnchor,
                                      trailing: trailingAnchor,
                                      paddingTop: innerSpacing)
            
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
                return
            }

            self?.country = value
        }

        let vc = CountryCodeSelectionViewController(presenter: presenter)
        if let topController = ViewControllerUtils.topBaseViewController {
            topController.showAsOverlay(item: vc, animated: true)
        }
    }
    
    //MARK: - Utils
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
            print("Generic parser error")
            return false
        }
    }
    
    private func runValidation() {
        if !Utils.isValidPhoneNumber(number: textView.text!) {
            showError()
        } else {
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
        guard let value = text else {
            return
        }
        
        textView.text = value
        textView.textColor = KarhooTextInputViewState.active.color
    }

    func dismissKeyboard() {
        textView.resignFirstResponder()
    }
    
    public func getFullPhoneNumber() -> String {
       return getInput()
   }

   public func getPhoneNumberNoCountryCode() -> String {
//       let isValid = validatePhoneNumber()
//       return isValid ? textView.text : ""
        return textView.text
   }

   public func getCountryCode() -> String {
        return country.phoneCode
   }
}

extension KarhooPhoneInputView: UITextViewDelegate {
    
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
    }
}
