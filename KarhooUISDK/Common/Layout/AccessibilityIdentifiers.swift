//
//  AccessibilityIdentifiers.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit

final class AccessibilityIdentifiers: UIView {

    @IBOutlet var hamburgerButtonId: [UIButton]?
    @IBOutlet var bookingLocateMeButtonId: [UIButton]?

    @IBOutlet var sideMenuLoginButtonId: [UIButton]?
    @IBOutlet var sideMenuSignupButtonId: [UIButton]?
    @IBOutlet var sideMenuProfileButtonId: [UIButton]?
    @IBOutlet var sideMenuFeedbackButtonId: [UIButton]?
    @IBOutlet var rideOptionsId: [UIButton]?
    
    @IBOutlet var firstNameFieldId: [KarhooTextField]?
    @IBOutlet var lastNameFieldId: [KarhooTextField]?
    @IBOutlet var emailFieldId: [KarhooTextField]?
    @IBOutlet var countryCodeFieldId: [KarhooTextField]?
    @IBOutlet var mobileNumberFieldId: [KarhooTextField]?
    @IBOutlet var passwordFieldId: [KarhooTextField]?
    @IBOutlet var invitationCodeFieldId: [KarhooTextField]?

    @IBOutlet var signupCancelButtonId: [UIBarButtonItem]?
    @IBOutlet var continueSignupButtonId: [FormButton]?
    @IBOutlet var promoOfferSwitchId: [UISwitch]?

    @IBOutlet var loginEmailFieldId: [KarhooTextField]?
    @IBOutlet var loginPasswordFieldId: [KarhooTextField]?

    @IBOutlet var loginCancelButtonId: [UIBarButtonItem]?
    @IBOutlet var loginContinueButtonId: [FormButton]?

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    func setup() {
        let aI = "accessibilityIdentifier"

        setValue("hamburger-button", forKeyPath: "hamburgerButtonId.\(aI)")
        setValue("booking-locate-me-button", forKeyPath: "bookingLocateMeButtonId.\(aI)")

        setValue("side-menu-login-button", forKeyPath: "sideMenuLoginButtonId.\(aI)")
        setValue("side-menu-signup-button", forKeyPath: "sideMenuSignupButtonId.\(aI)")
        setValue("ride-options-button", forKeyPath: "rideOptionsId.\(aI)")
        setValue("side-menu-profile-button", forKeyPath: "sideMenuProfileButtonId.\(aI)")
        setValue("side-menu-feedback-button", forKeyPath: "sideMenuFeedbackButtonId.\(aI)")

        setValue("signup-firstName-field", forKeyPath: "firstNameFieldId.\(aI)")
        setValue("signup-lastName-field", forKeyPath: "lastNameFieldId.\(aI)")
        setValue("signup-emailField-field", forKeyPath: "emailFieldId.\(aI)")
        setValue("signup-countryCode-field", forKeyPath: "countryCodeFieldId.\(aI)")
        setValue("signup-mobileNumber-field", forKeyPath: "mobileNumberFieldId.\(aI)")
        setValue("signup-password-field", forKeyPath: "passwordFieldId.\(aI)")

        setValue("signup-cancel-button", forKeyPath: "signupCancelButtonId.\(aI)")
        setValue("signup-continue-button", forKeyPath: "continueSignupButtonId.\(aI)")

        setValue("signup-promo-switch", forKeyPath: "promoOfferSwitchId.\(aI)")

        setValue("login-email-field", forKeyPath: "loginEmailFieldId.\(aI)")
        setValue("login-password-field", forKeyPath: "loginPasswordFieldId.\(aI)")

        setValue("login-cancel-button", forKeyPath: "loginCancelButtonId.\(aI)")
        setValue("login-continue-button", forKeyPath: "loginContinueButtonId.\(aI)")
    }
}
