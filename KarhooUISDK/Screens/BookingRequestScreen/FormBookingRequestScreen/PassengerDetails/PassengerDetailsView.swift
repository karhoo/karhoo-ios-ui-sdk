//
//  PassengerDetailsView.swift
//  KarhooUISDK
//
//  Created by Jeevan Thandi on 01/07/2020.
//  Copyright © 2020 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import KarhooSDK

final class PassengerDetailsView: UIView {

    private let textFieldInset: CGFloat = 30.0
    private var inputViews: [KarhooInputView] = []
    private var validSet = Set<String>()
    weak var actions: PassengerDetailsActions?

    var details: PassengerDetails? {
        willSet {
            firstNameTextField.set(text: newValue?.firstName)
            surnameTextField.set(text: newValue?.lastName)
            emailTextField.set(text: newValue?.email)
            phoneTextField.set(text: newValue?.phoneNumber)
        }
    }

    private lazy var firstNameTextField: KarhooTextInputView = {
        let firstNameTextField = KarhooTextInputView(contentType: .firstname,
                                            isOptional: false,
                                            accessibilityIdentifier: "firstNameField")
        firstNameTextField.delegate = self
        self.inputViews.append(firstNameTextField)
        return firstNameTextField
    }()

    private lazy var surnameTextField: KarhooTextInputView = {
        let surnameTextField = KarhooTextInputView(contentType: .surname,
                                                   isOptional: false,
                                                   accessibilityIdentifier: "surnameTextField")

        surnameTextField.delegate = self
        inputViews.append(surnameTextField)
        return surnameTextField
    }()

    private lazy var emailTextField: KarhooTextInputView = {
        let emailTextField = KarhooTextInputView(contentType: .email,
                                                 isOptional: false,
                                                 accessibilityIdentifier: "emailTextField")

        emailTextField.delegate = self
        inputViews.append(emailTextField)
        return emailTextField
    }()

    private lazy var phoneTextField: KarhooTextInputView = {
        let phoneTextField = KarhooTextInputView(contentType: .phone,
                                                 isOptional: false,
                                                 accessibilityIdentifier: "phoneTextField")

        phoneTextField.delegate = self
        inputViews.append(phoneTextField)
        return phoneTextField
    }()

    private lazy var textFieldStackView: UIStackView = {
        let textFieldStackView = UIStackView()
        textFieldStackView.accessibilityIdentifier = "base_stack_view"
        textFieldStackView.spacing = 15
        textFieldStackView.axis = .vertical
        textFieldStackView.translatesAutoresizingMaskIntoConstraints = false
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
            view.pinLeftRightEdegs(to: self,
                                   leading: textFieldInset,
                                   trailing: -textFieldInset)
        }
    }

    func getPassengerDetails() -> PassengerDetails {
        return PassengerDetails(firstName: firstNameTextField.getIntput(),
                                lastName: surnameTextField.getIntput(),
                                email: emailTextField.getIntput(),
                                phoneNumber: phoneTextField.getIntput(),
                                locale: "en-GB")
    }
}

extension PassengerDetailsView: KarhooInputViewDelegate {
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
