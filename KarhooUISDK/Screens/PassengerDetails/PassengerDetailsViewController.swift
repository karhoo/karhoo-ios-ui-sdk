//
//  PassengerDetailsViewController.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 25.08.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import UIKit
import KarhooSDK

struct KHPassengerDetailsViewID {
    static let scrollView = "scroll_view"
    static let mainStackView = "main_stack_view"
    static let backButton = "back_button"
    static let pageInfoStackView = "page_info_stack_view"
    static let pageTitleLabel = "page_title_label"
    static let pageSubtitleLabel = "page_subtitle_label"
    static let firstNameLabel = "first_name_label"
    static let firstNameInputView = "first_name_input_view"
    static let lastNameInputView = "last_name_input_view"
    static let emailInputView = "email_input_view"
    static let mobilePhoneInputView = "mobile_phone_input_view"
    static let doneButton = "done_button"
}

final class PassengerDetailsViewController: UIViewController, PassengerDetailsView, BaseViewController {

    private var presenter: PassengerDetailsPresenterProtocol
    private let keyboardSizeProvider: KeyboardSizeProviderProtocol = KeyboardSizeProvider.shared
    private let doneButtonHeight: CGFloat = 55.0
    private let standardButtonSize: CGFloat = 44.0
    private let standardMargin: CGFloat = 20.0
    private let standardSpacing: CGFloat = 20.0
    private let smallSpacing: CGFloat = 8.0
    private let extraSmallSpacing: CGFloat = 4.0
    private var inputViews = [KarhooInputView]()
    private var doneButtonBottomConstraint: NSLayoutConstraint!
    private var shouldMoveToNextInputViewOnReturn = true
    private let currentLocale = UITexts.Generic.locale
    private let shouldFocusNumberInputAutomatically: Bool
    
    // MARK: - PassengerDetailsView
    var delegate: PassengerDetailsDelegate? {
        didSet {
            presenter.delegate = delegate
        }
    }
    
    var details: PassengerDetails? {
        didSet {
            addPreInputtedDetails()
        }
    }
    
    var enableBackOption: Bool = true {
        didSet {
            backButton.isHidden = !enableBackOption
        }
    }
    
    // MARK: - Views and Controls
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor.white
        scrollView.accessibilityIdentifier = KHPassengerDetailsViewID.scrollView
        return scrollView
    }()

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.accessibilityIdentifier = KHPassengerDetailsViewID.mainStackView
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = standardSpacing
        return stackView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = KHPassengerDetailsViewID.backButton
        button.tintColor = KarhooUI.colors.text
        button.setImage(UIImage.uisdkImage("kh_uisdk_back_icon").withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitle(UITexts.Generic.back, for: .normal)
        button.setTitleColor(KarhooUI.colors.text, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12.0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: extraSmallSpacing, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var pageInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.accessibilityIdentifier = KHPassengerDetailsViewID.pageInfoStackView
        stackView.axis = .vertical
        stackView.spacing = smallSpacing
        return stackView
    }()
    
    private lazy var pageTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = KHPassengerDetailsViewID.pageTitleLabel
        label.font = KarhooUI.fonts.titleBold()
        label.textColor = KarhooUI.colors.text
        label.text = UITexts.PassengerDetails.title
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var pageSubtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = KHPassengerDetailsViewID.pageSubtitleLabel
        label.font = KarhooUI.fonts.bodyRegular()
        label.textColor = KarhooUI.colors.infoColor
        label.text = UITexts.PassengerDetails.subtitle
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var firstNameInputView: KarhooTextInputView = {
        let inputView = KarhooTextInputView(contentType: .firstname,
                                            isOptional: false,
                                            accessibilityIdentifier: KHPassengerDetailsViewID.firstNameInputView)
        inputView.delegate = self
        inputView.setBackgroundColor(KarhooUI.colors.background2)
        return inputView
    }()
    
    private lazy var lastNameInputView: KarhooTextInputView = {
        let inputView = KarhooTextInputView(contentType: .surname,
                                            isOptional: false,
                                            accessibilityIdentifier: KHPassengerDetailsViewID.lastNameInputView)
        inputView.delegate = self
        inputView.setBackgroundColor(KarhooUI.colors.background2)
        return inputView
    }()
    
    private lazy var emailNameInputView: KarhooTextInputView = {
        let inputView = KarhooTextInputView(contentType: .email,
                                            isOptional: false,
                                            accessibilityIdentifier: KHPassengerDetailsViewID.emailInputView)
        inputView.delegate = self
        inputView.setBackgroundColor(KarhooUI.colors.background2)
        return inputView
    }()
    
    private lazy var mobilePhoneInputView: KarhooPhoneInputView = {
        let inputView = KarhooPhoneInputView(
            accessibilityIdentifier: KHPassengerDetailsViewID.mobilePhoneInputView,
            shouldFocusNumberInputAutomatically: self.shouldFocusNumberInputAutomatically
        )
        inputView.delegate = self
        inputView.setBackgroundColor(KarhooUI.colors.background2)
        return inputView
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = KHPassengerDetailsViewID.doneButton
        button.anchor(height: doneButtonHeight)
        button.backgroundColor = KarhooUI.colors.secondary
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle(UITexts.PassengerDetails.saveAction.uppercased(), for: .normal)
        button.titleLabel?.font = KarhooUI.fonts.subtitleBold()
        button.layer.cornerRadius = 8.0
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    init(shouldFocusNumberInputAutomatically: Bool = true) {
        presenter = PassengerDetailsPresenter()
        self.shouldFocusNumberInputAutomatically = shouldFocusNumberInputAutomatically
        super.init(nibName: nil, bundle: nil)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
    
    private func setUpView() {
        view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.anchor(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.layer.cornerRadius = 10.0
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundClicked)))
        
        view.addSubview(backButton)
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          leading: view.leadingAnchor,
                          paddingTop: 15.0,
                          width: standardButtonSize * 2)
        
        view.addSubview(doneButton)
        doneButton.anchor(leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          paddingLeft: standardSpacing,
                          paddingRight: standardSpacing)
        enableDoneButton(false)
        doneButtonBottomConstraint = doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -standardSpacing)
        doneButtonBottomConstraint.isActive = true
        
        view.addSubview(scrollView)
        scrollView.anchor(top: backButton.bottomAnchor,
                          bottom: doneButton.topAnchor,
                          paddingTop: standardSpacing,
                          paddingBottom: standardSpacing)
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        scrollView.addSubview(mainStackView)
        mainStackView.anchor(top: scrollView.topAnchor,
                             leading: scrollView.leadingAnchor,
                             trailing: scrollView.trailingAnchor,
                             paddingTop: 0,
                             paddingLeft: standardMargin,
                             paddingRight: -standardMargin)
        mainStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        _ = mainStackView.bottomAnchor.constraint(greaterThanOrEqualTo: scrollView.bottomAnchor, constant: -standardSpacing).isActive = true
        
        mainStackView.addArrangedSubview(pageInfoStackView)
        pageInfoStackView.addArrangedSubview(pageTitleLabel)
        pageInfoStackView.addArrangedSubview(pageSubtitleLabel)
        
        mainStackView.addArrangedSubview(firstNameInputView)
        mainStackView.addArrangedSubview(lastNameInputView)
        mainStackView.addArrangedSubview(emailNameInputView)
        mainStackView.addArrangedSubview(mobilePhoneInputView)
        
        view.setNeedsDisplay()
        view.setNeedsLayout()
        view.setNeedsUpdateConstraints()
        
        inputViews = [firstNameInputView, lastNameInputView, emailNameInputView, mobilePhoneInputView]
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        forceLightMode()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardSizeProvider.register(listener: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardSizeProvider.remove(listener: self)
    }
    
    // MARK: - Actions
    @objc private func backButtonPressed() {
        dismissScreen()
        presenter.backClicked()
    }
    
    @objc private func donePressed() {
       dismissScreen()
        let details = PassengerDetails(firstName: firstNameInputView.getInput(),
                                       lastName: lastNameInputView.getInput(),
                                       email: emailNameInputView.getInput(),
                                       phoneNumber: mobilePhoneInputView.getFullPhoneNumber(),
                                       locale: currentLocale)
        let country = KarhooCountryParser.getCountry(countryCode: mobilePhoneInputView.getCountryCode()) ?? KarhooCountryParser.defaultCountry
        presenter.doneClicked(newDetails: details, country: country)
        dismissScreen()
    }
    
    @objc private func backgroundClicked() {
        shouldMoveToNextInputViewOnReturn = false
        view.endEditing(true)
    }
    
    // MARK: - Utils
    func enableDoneButton(_ shouldEnable: Bool) {
        doneButton.isEnabled = shouldEnable
        doneButton.alpha = shouldEnable ? 1.0 : 0.4
   }
    
    func dismissScreen() {
        self.dismiss(animated: false, completion: nil)
    }
    
    func addPreInputtedDetails() {
        guard let details = details else { return }
        
        firstNameInputView.set(text: details.firstName)
        lastNameInputView.set(text: details.lastName)
        emailNameInputView.set(text: details.email)
        mobilePhoneInputView.set(country: KarhooPassengerInfo.shared.getCountry())
        mobilePhoneInputView.set(text: details.phoneNumber)
        didBecomeInactive(identifier: KHPassengerDetailsViewID.mobilePhoneInputView)
        
        highlightInvalidFields()
    }
    
    private func highlightInvalidFields() {
        inputViews.forEach { inputView in
            if !inputView.isValid() {
                inputView.showError()
            }
        }
    }
}

extension PassengerDetailsViewController: PassengerDetailsActions {
    func passengerDetailsValid(_ isValid: Bool) {
        enableDoneButton(isValid)
    }
}

extension PassengerDetailsViewController: KarhooInputViewDelegate {
    func didBecomeInactive(identifier: String) {
        updateDoneButtonEnabled()
    }
    
    func didBecomeActive(identifier: String) {
        shouldMoveToNextInputViewOnReturn = true
    }
    
    func didChangeCharacterInSet(identifier: String) {
        updateDoneButtonEnabled()
    }
    
    private func getValidInputViewCount() -> Int {
        var validSet = Set<String>()
        
        inputViews.forEach { inputView in
            if inputView.isValid() {
                validSet.insert(inputView.accessibilityIdentifier ?? "")
            } else {
                validSet.remove(inputView.accessibilityIdentifier ?? "")
            }
        }
        
        return validSet.count
    }

    private func updateDoneButtonEnabled() {
        let validCount = getValidInputViewCount()
        passengerDetailsValid(validCount == inputViews.count)
    }

    private func scrollToActiveInputView() {
        var firstFocusedView: UIView? {
            inputViews.first(where: { $0.isFocused })
        }
        var firstResponderView: UIView? {
            inputViews.first(where: { $0.isFirstResponder() })
        }
        let activeInputView: UIView? = firstFocusedView ?? firstResponderView

        guard
            let rectToShow = activeInputView?.bounds,
            let translatedRect = activeInputView?.convert(rectToShow, to: scrollView)
        else { return }

        scrollView.scrollRectToVisible(translatedRect, animated: true)
    }
}

extension PassengerDetailsViewController: KeyboardListener {

    func keyboard(updatedHeight: CGFloat) {
        // This is to stop the animation of the done button's bottom constraint change
        UIView.animate(
            withDuration: UIConstants.Duration.short,
            animations: { [weak self] in
                guard let self = self else { return }
                self.doneButtonBottomConstraint.constant = -updatedHeight - self.standardSpacing
                self.view.layoutIfNeeded()
            },
            completion: { [weak self] _ in
                self?.scrollToActiveInputView()
            }
        )
    }
}
