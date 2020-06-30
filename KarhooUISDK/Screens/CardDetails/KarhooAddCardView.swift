//
//  KarhooAddCardView.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooSDK

public struct KHAddCardViewID {
    public static let view = "add_card_view"
    public static let image = "logo_image"
    public static let title = "title_label"
    public static let stackView = "stack_view_container"
    public static let button = "add_card_button"
    public static let editButton = "edit_card_button"
}

final class KarhooAddCardView: UIView, PaymentView {
    
    var baseViewController: BaseViewController?
    
    private var didSetupConstraints: Bool = false
    private var imageView: UIImageView!
    private var titleLabel: UILabel!
    private var button: UIButton!
    private var stackContainer: UIStackView!
    private var editButton: UIButton!
    private var dotBorderLayer: CAShapeLayer!
    private var hasPayment: Bool = false
    
    var quote: Quote?
    var actions: PaymentViewActions?
    private var presenter: CardDetailPresenter?
    
    init() {
        super.init(frame: .zero)
        
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        if !hasPayment && dotBorderLayer == nil {
            dotBorderLayer = CAShapeLayer()
            dotBorderLayer.strokeColor = KarhooUI.colors.paymentLightGrey.cgColor
            dotBorderLayer.lineDashPattern = [2, 2]
            dotBorderLayer.frame = bounds
            dotBorderLayer.fillColor = nil
            dotBorderLayer.path = UIBezierPath(rect: bounds).cgPath
            layer.addSublayer(dotBorderLayer)
        } else {
            dotBorderLayer.removeFromSuperlayer()
        }
    }
    
    private func setUpView() {
        backgroundColor = KarhooUI.colors.paymentLightGrey.withAlphaComponent(0.1)
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = KHAddCardViewID.view
        layer.cornerRadius = 4.0
        layer.masksToBounds = true
        
        stackContainer = UIStackView()
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        stackContainer.accessibilityIdentifier = KHAddCardViewID.stackView
        stackContainer.axis = .horizontal
        stackContainer.spacing = 15.0
        addSubview(stackContainer)
        
        imageView = UIImageView(image: UIImage.uisdkImage("add_destination").withRenderingMode(.alwaysTemplate))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = KarhooUI.colors.darkBlue
        imageView.accessibilityIdentifier = KHAddCardViewID.image
        stackContainer.addArrangedSubview(imageView)
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.accessibilityIdentifier = KHAddCardViewID.title
        titleLabel.text = UITexts.Payment.addPaymentMethod
        titleLabel.font = KarhooUI.fonts.getRegularFont(withSize: 14.0)
        titleLabel.textColor = KarhooUI.colors.darkNavy
        stackContainer.addArrangedSubview(titleLabel)
        
        button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = KHAddCardViewID.button
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        addSubview(button)
        
        editButton = UIButton(type: .custom)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.accessibilityIdentifier = KHAddCardViewID.editButton
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        editButton.setTitle(UITexts.Generic.edit, for: .normal)
        editButton.titleLabel?.font = KarhooUI.fonts.getRegularFont(withSize: 14.0)
        editButton.setTitleColor(KarhooUI.colors.darkBlue, for: .normal)
        editButton.isHidden = true
        addSubview(editButton)
        
        presenter = KarhooPaymentPresenter(view: self)
    }
    
    override func updateConstraints() {
        if !didSetupConstraints {
            
            let imageSize: CGFloat = 18.0
            _ = [imageView.widthAnchor.constraint(equalToConstant: imageSize),
                 imageView.heightAnchor.constraint(equalToConstant: imageSize)].map { $0.isActive = true }
            
            let stackInset: CGFloat = 14.0
            _ = [stackContainer.topAnchor.constraint(equalTo: topAnchor, constant: stackInset),
                 stackContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: stackInset),
                 stackContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -stackInset),
                 stackContainer.trailingAnchor.constraint(lessThanOrEqualTo: editButton.leadingAnchor,
                                                          constant: -5)].map { $0.isActive = true }
            
            _ = [button.topAnchor.constraint(equalTo: topAnchor),
                 button.leadingAnchor.constraint(equalTo: leadingAnchor),
                 button.trailingAnchor.constraint(equalTo: stackContainer.trailingAnchor),
                 button.bottomAnchor.constraint(equalTo: bottomAnchor)].map { $0.isActive = true }
            
            _ = [editButton.topAnchor.constraint(equalTo: topAnchor),
                 editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -stackInset),
                 editButton.bottomAnchor.constraint(equalTo: bottomAnchor)].map { $0.isActive = true }
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    @objc
    private func buttonTapped() {
        presenter?.updateCardPressed(showRetryAlert: false)
    }
    
    @objc
    private func editButtonTapped() {
        presenter?.updateCardPressed(showRetryAlert: false)
    }
    
    func set(nonce: Nonce) {
        titleLabel.text = UITexts.Payment.paymentMethod + " **** " + nonce.lastFour.suffix(4)
		imageView.image = UIImage.uisdkImage(nonce.cardType)

        updateViewState()
    }

    func noPaymentMethod() {
        resetViewState()
    }

    func retryAddPaymentMethod() {
        presenter?.updateCardPressed(showRetryAlert: true)
    }
    
    func set(paymentMethod: PaymentMethod) {
        titleLabel.text = UITexts.Payment.paymentMethod + " **** " + paymentMethod.paymentDescription.suffix(2)
		imageView.image = UIImage.uisdkImage(paymentMethod.nonceType)
        updateViewState()
        actions?.didGetNonce(nonce: paymentMethod.nonce)
    }
    
    private func updateViewState() {
        backgroundColor = KarhooUI.colors.white
        layer.borderWidth = 1.0
        layer.borderColor = KarhooUI.colors.guestCheckoutGrey.cgColor
        hasPayment = true
        editButton.isHidden = false
        button.isEnabled = false
        
        setNeedsDisplay()
    }
    
    private func resetViewState() {
        layer.borderWidth = 0.0
        layer.borderColor = UIColor.clear.cgColor
        backgroundColor = KarhooUI.colors.paymentLightGrey.withAlphaComponent(0.1)
        hasPayment = false
        editButton.isHidden = true
        titleLabel.text = UITexts.Payment.addPaymentMethod
        button.isEnabled = true
        
        setNeedsDisplay()
    }
    
    func validPayment() -> Bool {
        return hasPayment
    }
    
   func showError() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
        shakeView()
        
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.red.cgColor
    }
}
