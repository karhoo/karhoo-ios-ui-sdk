//
//  KarhooAddressBarFieldView.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit

public struct KHAddressBarFieldID {
    public static let label = "label"
    public static let clearButton = "clear_button"
}

public final class KarhooAddressBarFieldView: UIView, AddressBarFieldView {

    private weak var actions: AddressBarFieldActions?

    private var stackContainer: UIStackView!
    private var label: UILabel!
    private var clearButton: UIButton!
    private var textTapGesture: UITapGestureRecognizer!
    private var activityIndicatorView: UIActivityIndicatorView!
    
    private var didSetUpConstraints: Bool = false
    private var clearButtonDisabled: Bool = true

    init() {
        super.init(frame: .zero)
        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        textTapGesture = UITapGestureRecognizer(target: self, action: #selector(textTapped))
        addGestureRecognizer(textTapGesture)
        
        stackContainer = UIStackView()
        stackContainer.accessibilityIdentifier = "stackView"
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        stackContainer.axis = .horizontal
        stackContainer.distribution = .equalSpacing
        addSubview(stackContainer)
        
        label = UILabel()
        label.accessibilityIdentifier = KHAddressBarFieldID.label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = KarhooUI.fonts.bodyRegular()
        label.textColor = KarhooUI.colors.text
        label.text = ""
        label.numberOfLines = 2
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        stackContainer.addArrangedSubview(label)
    
        clearButton = UIButton(type: .custom)
        clearButton.accessibilityIdentifier = KHAddressBarFieldID.clearButton
        clearButton.accessibilityLabel = "\(UITexts.Accessibility.crossIcon), \(UITexts.Accessibility.deleteEntry)"
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.isHidden = clearButtonDisabled
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        clearButton.setImage(UIImage.uisdkImage("kh_uisdk_cross_in_circle"), for: .normal)
        clearButton.imageView?.contentMode = .scaleAspectFit
        clearButton.tintColor = KarhooUI.colors.textLabel
        stackContainer.addArrangedSubview(clearButton)
        
        activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.accessibilityIdentifier = "activity_indicator"
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicatorView)
        
        setUpConstraints()
    }
    
    public func setUpConstraints() {
        let topPadding: CGFloat = 10.0
        
        _ = [stackContainer.topAnchor.constraint(equalTo: topAnchor, constant: topPadding),
             stackContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
             stackContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5.0),
             stackContainer.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                    constant: -topPadding)].map { $0.isActive = true }
        
        clearButton.widthAnchor.constraint(equalToConstant: UIConstants.Dimension.Icon.standard).isActive = true
        clearButton.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
        
        _ = [activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)].map { $0.isActive = true }
    }
    
    public func updateViewLayout() {
        didSetUpConstraints = false
        clearButton.isHidden = clearButtonDisabled
    }
    
    func set(actions: AddressBarFieldActions?) {
        self.actions = actions
    }

    func set(text: String?) {
        guard let displayText = text, text != label?.text else { return }
        label?.text = displayText
        actions?.onFieldSet(sender: self)
    }

    func ordinaryTextColor() {
        label?.textColor = KarhooUI.colors.text
    }

    @objc
    private func clearButtonTapped() {
        actions?.onFieldClear(sender: self)
    }

    @objc
    private func textTapped() {
        actions?.onFieldSelect(sender: self)
    }

    func disable() {
        textTapGesture.isEnabled = false
        disableClear(true)
    }

    func disableClear(_ disabled: Bool) {
        clearButtonDisabled = disabled
        updateViewLayout()
    }

    func showSpinner() {
        activityIndicatorView?.startAnimating()
    }

    func hideSpinner() {
        activityIndicatorView?.stopAnimating()
    }
}
