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

final public class KarhooAddPaymentView: UIView, AddPaymentView {
    
    public var baseViewController: BaseViewController?
    
    private var didSetupConstraints: Bool = false
    
    private lazy var passengerPaymentImage: UIImageView = {
        let passengerPaymentIcon = UIImageView()
        passengerPaymentIcon.accessibilityIdentifier = KHAddCardViewID.image
        passengerPaymentIcon.translatesAutoresizingMaskIntoConstraints = false
        passengerPaymentIcon.image = UIImage.uisdkImage("plus_icon")
        passengerPaymentIcon.tintColor = KarhooUI.colors.darkGrey
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
        passengerPaymentSubtitleLabel.textColor = KarhooUI.colors.accent
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
    var actions: AddPaymentViewDelegate? {
        didSet {
            if presenter == nil {
                presenter = KarhooAddPaymentPresenter(view: self)
            }
        }
    }
    private var presenter: AddPaymentPresenter?
    
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
            dotBorderLayer.strokeColor = KarhooUI.colors.medGrey.cgColor
            dotBorderLayer.lineDashPattern = [4, 4]
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
        isAccessibilityElement = true
        layer.cornerRadius = 4.0
        layer.masksToBounds = true
        accessibilityLabel = UITexts.Payment.addPaymentMethod
        accessibilityTraits = .button

        addSubview(stackContainer)

        stackContainer.addArrangedSubview(passengerPaymentImage)
        stackContainer.addArrangedSubview(passengerPaymentTitle)
        stackContainer.addArrangedSubview(passengerPaymentSubtitle)
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
        passengerPaymentTitle.text = "\(UITexts.Payment.paymentMethod) **** \(nonce.lastFour)"
        passengerPaymentSubtitle.text = UITexts.Generic.edit
		passengerPaymentImage.image = UIImage.uisdkImage(nonce.cardType)
        accessibilityLabel = "\(UITexts.Payment.paymentMethod): \(nonce.lastFour.split(separator: " ").joined())"
        accessibilityHint = UITexts.Generic.edit

        updateViewState()
        actions?.didGetNonce(nonce: nonce)
    }

    func noPaymentMethod() {
        resetViewState()
    }

    func startRegisterCardFlow(showRetryAlert: Bool = true) {
        presenter?.updateCardPressed(showRetryAlert: showRetryAlert)
    }
    
    private func updateViewState() {
        layer.borderWidth = 1.0
        layer.borderColor = KarhooUI.colors.lightGrey.cgColor
        hasPayment = true
        
        setNeedsDisplay()
    }
    
    private func resetViewState() {
        layer.borderWidth = 0.0
        layer.borderColor = UIColor.clear.cgColor
        hasPayment = false
        passengerPaymentTitle.text = UITexts.Booking.guestCheckoutPaymentDetailsTitle
        passengerPaymentSubtitle.text = UITexts.Payment.addPaymentMethod
        passengerPaymentImage.image = UIImage.uisdkImage("plus_icon")
        
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
