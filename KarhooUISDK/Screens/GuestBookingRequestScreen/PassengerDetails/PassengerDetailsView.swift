//
//  PassengerDetailsView.swift
//  KarhooUISDK
//
//  Created by Jeevan Thandi on 01/07/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation

protocol PassengerDetailsViewP: UIView {

}

protocol PassengerDetailsPresenter {

}

final class PassengerDetailsView: UIView, KarhooInputViewDelegate {

    private let textFieldInset: CGFloat = 30.0

    var details: PassengerInfo? {
        willSet {
            firstNameTextField.set(text: newValue?.passengerDetails?.firstName)
            surnameTextField.set(text: newValue?.passengerDetails?.lastName)
            emailTextField.set(text: newValue?.passengerDetails?.email)
            commentsTextField.set(text: newValue?.passengerDetails?.phoneNumber)
        }
    }

    private lazy var firstNameTextField: KarhooTextInputView = {
        let firstNameTextField = KarhooTextInputView(contentType: .firstname,
                                            isOptional: false,
                                            accessibilityIdentifier: "firstNameField")
        firstNameTextField.delegate = self
        return firstNameTextField
    }()

    private lazy var surnameTextField: KarhooTextInputView = {
        let surnameTextField = KarhooTextInputView(contentType: .surname,
                                                   isOptional: false,
                                                   accessibilityIdentifier: "surnameTextField")

        surnameTextField.delegate = self
        return surnameTextField
    }()

    private lazy var emailTextField: KarhooTextInputView = {
        let emailTextField = KarhooTextInputView(contentType: .email,
                                                 isOptional: false,
                                                 accessibilityIdentifier: "emailTextField")

        emailTextField.delegate = self
        return emailTextField
    }()

    private lazy var phoneTextField: KarhooTextInputView = {
        let phoneText = KarhooTextInputView(contentType: .phone,
                                                 isOptional: false,
                                                 accessibilityIdentifier: "phoneTextField")

        phoneText.delegate = self
        return phoneText
    }()

    private lazy var commentsTextField: KarhooTextInputView = {
        let commentsTextField = KarhooTextInputView(contentType: .comment,
                                                    isOptional: true,
                                                    accessibilityIdentifier: "commentsTextField")

        commentsTextField.delegate = self
        return commentsTextField
    }()

    private lazy var textFieldStackView: UIStackView = {
        let textFieldStackView = UIStackView()
        textFieldStackView.accessibilityIdentifier = "base_stack_view"
        textFieldStackView.spacing = 15
        textFieldStackView.axis = .vertical
        return textFieldStackView
    }()

    init() {
        super.init(frame: .zero)
        self.setUpView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpView() {
        self.addSubview(textFieldStackView)
        textFieldStackView.pinEdges(to: self)

        textFieldStackView.addArrangedSubview(firstNameTextField)
        textFieldStackView.addArrangedSubview(surnameTextField)
        textFieldStackView.addArrangedSubview(emailTextField)
        textFieldStackView.addArrangedSubview(phoneTextField)

        layoutTextFields()
    }

    private func layoutTextFields() {
        [firstNameTextField,
         surnameTextField,
         emailTextField,
         phoneTextField].forEach { view in
            view.pinLeftRightEdegs(to:  self,
                                   leading: textFieldInset,
                                   trailing: -textFieldInset)
        }
    }

    func didBecomeInactive(identifier: String) {}
}
