//
//  KarhooAddPassengerDetailsView.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 26.08.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import UIKit
import KarhooSDK

public struct KHAddPassengerDetailsViewID {
    public static let container = "container_view"
    public static let stackView = "main_stack_view"
    public static let image = "logo_image"
    public static let title = "title_label"
    public static let subtitle = "subtitle_label"
}

final class KarhooAddPassengerDetailsView: UIView, AddPassengerView {
    
    var baseViewController: BaseViewController?
    private var didSetupConstraints: Bool = false
    private var presenter: KarhooAddPassengerDetailsPresenter?
    var actions: AddPassengerDetailsViewDelegate?
    private var dotBorderLayer: CAShapeLayer!
    private var hasValidDetails: Bool = false
    
    private lazy var passengerDetailsContainer: UIView = {
        let passengerDetailsView = UIView()
        passengerDetailsView.accessibilityIdentifier = KHAddPassengerDetailsViewID.container
        passengerDetailsView.layer.masksToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(passengerDetailsViewTapped))
        passengerDetailsView.addGestureRecognizer(tapGesture)
        
        return passengerDetailsView
    }()
    
    private lazy var passengerDetailsStackView: UIStackView = {
        let passengerDetailsStackView = UIStackView()
        passengerDetailsStackView.accessibilityIdentifier = KHAddPassengerDetailsViewID.stackView
        passengerDetailsStackView.translatesAutoresizingMaskIntoConstraints = false
        passengerDetailsStackView.alignment = .center
        passengerDetailsStackView.axis = .vertical
        passengerDetailsStackView.distribution = .equalSpacing
        passengerDetailsStackView.spacing = 5.0
        
        return passengerDetailsStackView
    }()
    
    private lazy var passengerDetailsImage: UIImageView = {
        let passengerDetailsIcon = UIImageView()
        passengerDetailsIcon.accessibilityIdentifier = KHAddPassengerDetailsViewID.image
        passengerDetailsIcon.translatesAutoresizingMaskIntoConstraints = false
        passengerDetailsIcon.image = UIImage.uisdkImage("user_icon")
        passengerDetailsIcon.tintColor = KarhooUI.colors.darkGrey
        passengerDetailsIcon.contentMode = .scaleAspectFit
        
        return passengerDetailsIcon
    }()
    
    private lazy var passengerDetailsTitle: UILabel = {
        let passengerDetailsTitleLabel = UILabel()
        passengerDetailsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        passengerDetailsTitleLabel.accessibilityIdentifier = KHAddPassengerDetailsViewID.title
        passengerDetailsTitleLabel.textColor = KarhooUI.colors.primaryTextColor
        passengerDetailsTitleLabel.textAlignment = .center
        passengerDetailsTitleLabel.text = UITexts.Booking.passenger
        passengerDetailsTitleLabel.font = KarhooUI.fonts.getBoldFont(withSize: 12.0)
        
        return passengerDetailsTitleLabel
    }()
    
    private lazy var passengerDetailsSubtitle: UILabel = {
        let passengerDetailsSubtitleLabel = UILabel()
        passengerDetailsSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        passengerDetailsSubtitleLabel.accessibilityIdentifier = KHAddPassengerDetailsViewID.subtitle
        passengerDetailsSubtitleLabel.textColor = KarhooUI.colors.accent
        passengerDetailsSubtitleLabel.textAlignment = .center
        passengerDetailsSubtitleLabel.text = UITexts.Booking.guestCheckoutPassengerDetailsTitle
        passengerDetailsSubtitleLabel.font = KarhooUI.fonts.getRegularFont(withSize: 10.0)
        
        return passengerDetailsSubtitleLabel
    }()
    
    init() {
        super.init(frame: .zero)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        if !hasValidDetails && dotBorderLayer == nil {
            dotBorderLayer = CAShapeLayer()
            dotBorderLayer.strokeColor = KarhooUI.colors.medGrey.cgColor
            dotBorderLayer.lineDashPattern = [4, 4]
            dotBorderLayer.frame = bounds
            dotBorderLayer.fillColor = nil
            dotBorderLayer.path = UIBezierPath(rect: bounds).cgPath
            layer.addSublayer(dotBorderLayer)
        }
    }
    
    private func setupView() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = KHAddPassengerDetailsAndPaymentViewID.container
        layer.cornerRadius = 4.0
        layer.masksToBounds = true
        
        addSubview(passengerDetailsContainer)
        
        passengerDetailsStackView.addArrangedSubview(passengerDetailsImage)
        passengerDetailsStackView.addArrangedSubview(passengerDetailsTitle)
        passengerDetailsStackView.addArrangedSubview(passengerDetailsSubtitle)

        passengerDetailsContainer.addSubview(passengerDetailsStackView)
        
        presenter = KarhooAddPassengerDetailsPresenter(view: self)
    }
    
    override func updateConstraints() {
        if !didSetupConstraints {
            passengerDetailsContainer.anchor(top: self.topAnchor,
                                             leading: self.leadingAnchor,
                                             bottom: self.bottomAnchor,
                                             trailing: self.trailingAnchor)
            
            passengerDetailsStackView.anchor(top: passengerDetailsContainer.topAnchor,
                                             leading: passengerDetailsContainer.leadingAnchor,
                                             bottom: passengerDetailsContainer.bottomAnchor,
                                             trailing: passengerDetailsContainer.trailingAnchor,
                                             paddingTop: 12.0,
                                             paddingBottom: 12.0)
            
            passengerDetailsImage.anchor(leading: passengerDetailsStackView.leadingAnchor,
                                         trailing: passengerDetailsStackView.trailingAnchor,
                                         paddingLeft: 56.0,
                                         paddingRight: 56.0,
                                         width: 24.0,
                                         height: 24.0)
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    @objc private func passengerDetailsViewTapped() {
        actions?.willUpdatePassengerDetails()
    }
    
    func setBaseViewController(_ vc: BaseViewController) {
        baseViewController = vc
    }
    
    func set(details: PassengerDetails?) {
        presenter?.set(details: details)
        actions?.didUpdatePassengerDetails(details: details)
    }
    
    func validDetails() -> Bool {
        return hasValidDetails
    }
    
    func showError() {
         let generator = UINotificationFeedbackGenerator()
         generator.notificationOccurred(.error)
         shakeView()
         
         layer.borderWidth = 1.0
         layer.borderColor = UIColor.red.cgColor
     }
    
    func updatePassengerSummary(details: PassengerDetails?) {
        guard let details = details
        else {
            passengerDetailsTitle.text = UITexts.PassengerDetails.title
            passengerDetailsSubtitle.text = UITexts.PassengerDetails.add
            return
        }
        
        passengerDetailsTitle.text = "\(details.firstName) \(details.lastName)"
        passengerDetailsSubtitle.text = UITexts.Generic.edit
    }
    
    func updateViewState() {
        setFullBorder(true)
        hasValidDetails = true
        setNeedsDisplay()
    }
    
     func resetViewState() {
        setFullBorder(false)
        hasValidDetails = false
        passengerDetailsTitle.text = UITexts.PassengerDetails.title
        passengerDetailsSubtitle.text = UITexts.PassengerDetails.add
        passengerDetailsImage.image = UIImage.uisdkImage("user_icon")
        
        setNeedsDisplay()
    }
    
    func resetViewBorder() {
        setFullBorder(false)
        hasValidDetails = false
        setNeedsDisplay()
    }
    
    private func setFullBorder(_ shouldSet: Bool) {
        layer.borderWidth = shouldSet ? 1.0 : 0.0
        layer.borderColor = shouldSet ? KarhooUI.colors.lightGrey.cgColor : UIColor.clear.cgColor
    }
}
