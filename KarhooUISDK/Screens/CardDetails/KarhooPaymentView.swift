//
//  CardDetailsView.swift
//  CardsDetails
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit
import KarhooSDK

public struct KHCardDetailsViewID {
    public static let cardIcon = "card_Icon_ImageView"
    public static let cardDigits = "card_digits_Label"
    public static let updateButton = "update_Button"
}

public final class KarhooPaymentView: UIView, PaymentView {

    public var baseViewController: BaseViewController?
    var quote: Quote?
    var actions: PaymentViewActions?
    var nonce: String?
    // UI Components
    private var cardIcon: UIImageView!
    private var cardDigits: UILabel!
    private var updateButton: UIButton!
    private var didSetupConstraints: Bool = false
    private var presenter: PaymentPresenter?

    init() {
        super.init(frame: .zero)
        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpView()
    }
    
    override public func updateConstraints() {
        if !didSetupConstraints {
            // card icon
            _ = [cardIcon.trailingAnchor.constraint(equalTo: cardDigits.leadingAnchor, constant: -20.0),
                 cardIcon.heightAnchor.constraint(equalToConstant: 35.0),
                 cardIcon.widthAnchor.constraint(equalToConstant: 35.0),
                 cardIcon.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0),
                 cardIcon.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5.0)]
                .map { $0.isActive = true }
            // card digits
            _ = [cardDigits.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                 cardDigits.centerXAnchor.constraint(equalTo: self.centerXAnchor)]
                .map { $0.isActive = true }
            // update button
            _ = [updateButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                 updateButton.leadingAnchor.constraint(equalTo: cardDigits.trailingAnchor, constant: 20.0)]
                .map { $0.isActive = true }
            
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
    
    private func setUpView() {
        accessibilityIdentifier = "cardDetails_view"
        backgroundColor = .clear

        cardIcon = UIImageView()
        cardIcon.accessibilityIdentifier = KHCardDetailsViewID.cardIcon
        cardIcon.image = UIImage.uisdkImage("card_icon")
        cardIcon.translatesAutoresizingMaskIntoConstraints = false
        addSubview(cardIcon)

        cardDigits = UILabel()
        cardDigits.translatesAutoresizingMaskIntoConstraints = false
        cardDigits.accessibilityIdentifier = KHCardDetailsViewID.cardDigits
        cardDigits.textAlignment = .center
        cardDigits.font = KarhooUI.fonts.bodyRegular()
        cardDigits.textColor = KarhooUI.colors.darkGrey
        cardDigits.text = ""
        addSubview(cardDigits)

        updateButton = UIButton(type: .custom)
        updateButton.accessibilityIdentifier = KHCardDetailsViewID.updateButton
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        updateButton.setTitle(UITexts.Generic.add, for: .normal)
        updateButton.setTitleColor(KarhooUI.colors.medGrey, for: .normal)
        updateButton.titleLabel?.font = KarhooUI.fonts.bodyBold()
        updateButton.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
        addSubview(updateButton)
        
        presenter = KarhooPaymentPresenter(view: self)
    }

    @objc
    private func updateButtonTapped() {
        presenter?.updateCardPressed(showRetryAlert: false)
    }

    func set(paymentMethod: PaymentMethod) {
        cardDigits.text = paymentMethod.paymentDescription
        cardIcon.image = UIImage.uisdkImage(paymentMethod.nonceType)
        updateButton.setTitle(UITexts.Generic.change, for: .normal)
        actions?.didGetNonce(nonce: paymentMethod.nonce)
        self.nonce = paymentMethod.nonce
    }

    func set(nonce: Nonce) {
        updateButton.setTitle(UITexts.Generic.change, for: .normal)
        cardDigits.text = "•••• " + nonce.lastFour.suffix(4)
        cardIcon.image = UIImage.uisdkImage(nonce.cardType)
    }

    func noPaymentMethod() {
        updateButton.setTitle(UITexts.Generic.add, for: .normal)
    }

    func retryAddPaymentMethod() {
        presenter?.updateCardPressed(showRetryAlert: true)
    }
}
