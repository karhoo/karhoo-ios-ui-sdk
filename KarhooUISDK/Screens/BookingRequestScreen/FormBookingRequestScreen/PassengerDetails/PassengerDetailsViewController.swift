//
//  PassengerDetailsViewController.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 25.08.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import UIKit

struct KHPassengerDetailsViewID {
    static let scrollView = "scroll_view"
    static let mainStackView = "main_stack_view"
    static let toolbarView = "toolbar_view"
    static let backButton = "back_button"
    static let pageInfoStackView = "page_info_stack_view"
    static let pageTitleLabel = "page_title_label"
    static let pageSubtitleLabel = "page_subtitle_label"
    static let firstNameLabel = "first_name_label"
    static let firstNameInputView = "first_name_input_view"
    static let lastNameInputView = "last_name_input_view"
    static let emailInputView = "email_input_view"
    static let mobilePhoneInputView = "mobile_phone_input_view"
}

final class PassengerDetailsViewController: UIViewController {
    
    private var presenter: PassengerDetailsPresenterProtocol
    private let standardButtonSize: CGFloat = 44.0
    private let standardMargin: CGFloat = 30.0
    private let standardSpacing: CGFloat = 20.0
    private let smallSpacing: CGFloat = 8.0
    private let extraSmallSpacing: CGFloat = 4.0
    private var inputViews = [KarhooInputView]()
    private var validSet = Set<String>()
    weak var actions: PassengerDetailsActions?
    
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
    
    private lazy var toolbarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = KHPassengerDetailsViewID.toolbarView
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = KHPassengerDetailsViewID.backButton
        button.tintColor = KarhooUI.colors.darkGrey
        button.setImage(UIImage.uisdkImage("backIcon"), for: .normal) //.withRenderingMode(.alwaysTemplate), for: .normal)
        button.setTitle(UITexts.Generic.back, for: .normal)
        button.setTitleColor(KarhooUI.colors.darkGrey, for: .normal)
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
        label.textColor = KarhooUI.colors.infoColor
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
        return inputView
    }()
    
    private lazy var lastNameInputView: KarhooTextInputView = {
        let inputView = KarhooTextInputView(contentType: .surname,
                                            isOptional: false,
                                            accessibilityIdentifier: KHPassengerDetailsViewID.lastNameInputView)
        inputView.delegate = self
        return inputView
    }()
    
    private lazy var emailNameInputView: KarhooTextInputView = {
        let inputView = KarhooTextInputView(contentType: .email,
                                            isOptional: false,
                                            accessibilityIdentifier: KHPassengerDetailsViewID.emailInputView)
        inputView.delegate = self
        return inputView
    }()
    
    private lazy var mobilePhoneInputView: KarhooPhoneInputView = {
        let inputView = KarhooPhoneInputView(accessibilityIdentifier: KHPassengerDetailsViewID.mobilePhoneInputView)
        inputView.delegate = self
        return inputView
    }()
    
    private lazy var bookingButton: KarhooBookingButtonView = {
        let button = KarhooBookingButtonView()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.anchor(height: 55.0)
        button.set(actions: self)
        button.set(buttonTitle: UITexts.PassengerDetails.doneAction)
        return button
    }()
    
    // MARK: - Init
    init(presenter: PassengerDetailsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.anchor(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        setUpView()
    }
    
    private func setUpView() {
        view.addSubview(scrollView)
        scrollView.anchor(top: self.view.topAnchor,
                          bottom: self.view.bottomAnchor)
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        scrollView.addSubview(mainStackView)
        mainStackView.anchor(top: scrollView.topAnchor,
                             leading: scrollView.leadingAnchor,
                             bottom: scrollView.bottomAnchor,
                             trailing: scrollView.trailingAnchor,
                             paddingTop: standardMargin,
                             paddingLeft: standardMargin,
                             paddingBottom: -standardMargin,
                             paddingRight: -standardMargin)
        mainStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        mainStackView.addArrangedSubview(toolbarView)
        toolbarView.addSubview(backButton)
        backButton.anchor(top: toolbarView.topAnchor,
                          leading: toolbarView.leadingAnchor,
                          bottom: toolbarView.bottomAnchor,
                          paddingLeft: -standardMargin,
                          width: standardButtonSize * 2,
                          height: standardButtonSize)
        
        mainStackView.addArrangedSubview(pageInfoStackView)
        pageInfoStackView.addArrangedSubview(pageTitleLabel)
        pageInfoStackView.addArrangedSubview(pageSubtitleLabel)
        
        mainStackView.addArrangedSubview(firstNameInputView)
        mainStackView.addArrangedSubview(lastNameInputView)
        mainStackView.addArrangedSubview(emailNameInputView)
        mainStackView.addArrangedSubview(mobilePhoneInputView)
        
        view.addSubview(bookingButton)
        bookingButton.anchor(leading: view.leadingAnchor,
                             bottom: view.bottomAnchor,
                             trailing: view.trailingAnchor,
                             paddingLeft: standardSpacing,
                             paddingBottom: standardSpacing,
                             paddingRight: standardSpacing)
        
        view.setNeedsDisplay()
        view.setNeedsLayout()
        view.setNeedsUpdateConstraints()
        
        inputViews = [firstNameInputView, lastNameInputView, emailNameInputView, mobilePhoneInputView]
    }
    
    // MARK: - Actions
    @objc func backButtonPressed() {
        self.dismiss(animated: false, completion: nil)
    }
}

extension PassengerDetailsViewController: PassengerDetailsActions {
    func passengerDetailsValid(_: Bool) {
        
    }
}

extension PassengerDetailsViewController: KarhooInputViewDelegate {
    func didBecomeInactive(identifier: String) {
        for (index, inputView) in inputViews.enumerated() {
            if inputView.isValid() {
                validSet.insert(inputView.accessibilityIdentifier!)
            } else {
                validSet.remove(inputView.accessibilityIdentifier!)
            }
            if inputView.accessibilityIdentifier == identifier {
                if index != inputViews.count - 1 {
                    inputViews[index + 1].setActive()
                }
            }
        }

        actions?.passengerDetailsValid(validSet.count == inputViews.count)
    }
}

extension PassengerDetailsViewController: KarhooTextFieldStateDelegate {
    func didChange(text: String, isValid: Bool, identifier: Int) {
        // TODO: check if method is needed. If not, erase it
    }
}

extension PassengerDetailsViewController: BookingButtonActions {
    func requestPressed() {
        // TODO: Save passenger details
    }
    
    func addFlightDetailsPressed() {
        // Do Nothing
    }
}
