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
    public static let subtitle = "subtitle_label"
    public static let stackView = "stack_view_container"
}

final public class KarhooAddCardView: UIView, PaymentView {
    
    public var baseViewController: BaseViewController?
    
    private var didSetupConstraints: Bool = false
    
    private lazy var passengerPaymentImage: UIImageView = {
        let passengerPaymentIcon = UIImageView()
        passengerPaymentIcon.accessibilityIdentifier = KHAddCardViewID.image
        passengerPaymentIcon.translatesAutoresizingMaskIntoConstraints = false
        passengerPaymentIcon.image = UIImage.uisdkImage("plus_icon")
        passengerPaymentIcon.tintColor = KarhooUI.colors.infoColor
        passengerPaymentIcon.contentMode = .scaleAspectFit
        
        return passengerPaymentIcon
    }()
    
    private lazy var passengerPaymentTitle: UILabel = {
        let passengerPaymentTitleLabel = UILabel()
        passengerPaymentTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        passengerPaymentTitleLabel.accessibilityIdentifier = KHAddCardViewID.title
        passengerPaymentTitleLabel.textColor = KarhooUI.colors.primaryTextColor
        passengerPaymentTitleLabel.textAlignment = .center
        passengerPaymentTitleLabel.text = UITexts.Booking.guestCheckoutPaymentDetailsTitle
        passengerPaymentTitleLabel.font = KarhooUI.fonts.getBoldFont(withSize: 12.0)
        passengerPaymentTitleLabel.numberOfLines = 0
        
        return passengerPaymentTitleLabel
    }()
    
    private lazy var passengerPaymentSubtitle: UILabel = {
        let passengerPaymentSubtitleLabel = UILabel()
        passengerPaymentSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        passengerPaymentSubtitleLabel.accessibilityIdentifier = KHAddCardViewID.subtitle
        passengerPaymentSubtitleLabel.textColor = KarhooUI.colors.primaryTextColor
        passengerPaymentSubtitleLabel.textAlignment = .center
        passengerPaymentSubtitleLabel.text = UITexts.Payment.addPaymentMethod
        passengerPaymentSubtitleLabel.font = KarhooUI.fonts.getRegularFont(withSize: 10.0)
        
        return passengerPaymentSubtitleLabel
    }()
    
    private lazy var stackContainer: UIStackView = {
        
        let passengerPaymentStackView = UIStackView()
        passengerPaymentStackView.accessibilityIdentifier = KHAddCardViewID.stackView
        passengerPaymentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        passengerPaymentStackView.alignment = .center
        passengerPaymentStackView.axis = .vertical
        passengerPaymentStackView.distribution = .equalSpacing
        passengerPaymentStackView.spacing = 5.0

        return passengerPaymentStackView
    }()
    
    private var dotBorderLayer: CAShapeLayer!
    private var hasPayment: Bool = false
    
    var quote: Quote?
    var actions: PaymentViewActions?
    private var presenter: PaymentPresenter?
    
    public init() {
        super.init(frame: .zero)
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func draw(_ rect: CGRect) {
        super.draw(rect)

        if !hasPayment && dotBorderLayer == nil {
            dotBorderLayer = CAShapeLayer()
            dotBorderLayer.strokeColor = KarhooUI.colors.lightGrey.cgColor
            dotBorderLayer.lineDashPattern = [2, 2]
            dotBorderLayer.frame = bounds
            dotBorderLayer.fillColor = nil
            dotBorderLayer.path = UIBezierPath(rect: bounds).cgPath
            layer.addSublayer(dotBorderLayer)
        }
    }

    private func setUpView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(paymentViewTapped))
        addGestureRecognizer(tapGesture)
        
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = KHAddCardViewID.view
        layer.cornerRadius = 4.0
        layer.masksToBounds = true

        addSubview(stackContainer)

        stackContainer.addArrangedSubview(passengerPaymentImage)
        stackContainer.addArrangedSubview(passengerPaymentTitle)
        stackContainer.addArrangedSubview(passengerPaymentSubtitle)

        presenter = KarhooPaymentPresenter(view: self)
    }

    override public func updateConstraints() {
        if !didSetupConstraints {

            passengerPaymentImage.anchor(leading: leadingAnchor,
                                         trailing: trailingAnchor,
                                         paddingLeft: 56.0,
                                         paddingRight: 56.0,
                                         width: 24.0,
                                         height: 24.0)

            let stackInset: CGFloat = 12.0
            stackContainer.anchor(top: topAnchor,
                                  leading: leadingAnchor,
                                  bottom: bottomAnchor,
                                  trailing: trailingAnchor,
                                  paddingTop: stackInset,
                                  paddingBottom: stackInset)

            didSetupConstraints = true
        }

        super.updateConstraints()
    }
    
    @objc
    private func paymentViewTapped() {
        presenter?.updateCardPressed(showRetryAlert: false)
    }
    
    func setBaseViewController(_ vc: BaseViewController) {
        baseViewController = vc
    }
    
    func set(nonce: Nonce) {
        passengerPaymentTitle.text = UITexts.Payment.paymentMethod + " **** " + nonce.lastFour.suffix(4)
		passengerPaymentImage.image = UIImage.uisdkImage(nonce.cardType)

        updateViewState()
    }

    func noPaymentMethod() {
        resetViewState()
    }

    func startRegisterCardFlow() {
        presenter?.updateCardPressed(showRetryAlert: true)
    }
    
    func set(paymentMethod: PaymentMethod) {
        passengerPaymentTitle.text = UITexts.Payment.paymentMethod + " **** " + paymentMethod.paymentDescription.suffix(2)
        passengerPaymentSubtitle.text = UITexts.Generic.edit
		passengerPaymentImage.image = UIImage.uisdkImage(paymentMethod.nonceType)
        updateViewState()
        actions?.didGetNonce(nonce: paymentMethod.nonce)
        //self.nonce = paymentMethod.nonce
    }
    
    private func updateViewState() {
        layer.borderWidth = 1.0
        layer.borderColor = KarhooUI.colors.guestCheckoutGrey.cgColor
        hasPayment = true
        
        setNeedsDisplay()
    }
    
    private func resetViewState() {
        layer.borderWidth = 0.0
        layer.borderColor = UIColor.clear.cgColor
        hasPayment = false
        passengerPaymentTitle.text = UITexts.Booking.guestCheckoutPaymentDetailsTitle
        passengerPaymentSubtitle.text = UITexts.Payment.addPaymentMethod
        
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
