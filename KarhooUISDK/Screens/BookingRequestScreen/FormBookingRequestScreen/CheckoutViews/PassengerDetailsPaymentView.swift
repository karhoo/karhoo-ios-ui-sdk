//
//  PassengerDetailsPaymentView.swift
//  KarhooUISDK
//
//  Created by Anca Feurdean on 12.08.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import UIKit
import KarhooSDK

public struct KHPassengerDetailsPaymentViewID {
    public static let container = "passenger_details_payment_container"
    public static let passengerDetailsPaymentStackView = "passenger_details_payment_stack_view"
    public static let passengerDetailsContainer = "passenger_details_container"
    public static let passengerPaymentContainer = "passenger_payment_container"
    public static let passengerDetailsStackView = "passenger_details_stack_view"
    public static let passengerPaymentStackView = "passenger_payment_stack_view"
    public static let passengerDetailsImage = "passenger_details_image"
    public static let passengerPaymentImage = "passenger_payment_image"
    public static let passengerDetailsTitle = "passenger_details_title"
    public static let passengerPaymentTitle = "passenger_payment_title"
    public static let passengerDetailsSubtitle = "passenger_details_subtitle"
    public static let passengerPaymentSubtitle = "passenger_payment_subtitle"
}

final class PassengerDetailsPaymentView: UIView {
    
    private var didSetupConstraints: Bool = false

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.accessibilityIdentifier = KHPassengerDetailsPaymentViewID.passengerDetailsPaymentStackView
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 16.0
        
        return stackView
    }()
    
    private lazy var passengerDetailsContainer: UIView = {
        let passengerDetailsView = UIView()
        passengerDetailsView.accessibilityIdentifier = KHPassengerDetailsPaymentViewID.passengerDetailsContainer
        passengerDetailsView.layer.cornerRadius = 5.0
        passengerDetailsView.layer.borderColor = KarhooUI.colors.lightGrey.cgColor
        passengerDetailsView.layer.borderWidth = 0.5
        passengerDetailsView.layer.masksToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(passengerDetailsViewTapped))
        passengerDetailsView.addGestureRecognizer(tapGesture)
        
        return passengerDetailsView
    }()
    
    private lazy var passengerPaymentContainer: PaymentView = {
        let passengerPaymentView = KarhooAddCardView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(paymentViewTapped))
        passengerPaymentView.addGestureRecognizer(tapGesture)
        
        return passengerPaymentView
    }()
    
    private lazy var passengerDetailsStackView: UIStackView = {
        let passengerDetailsStackView = UIStackView()
        passengerDetailsStackView.accessibilityIdentifier = KHPassengerDetailsPaymentViewID.passengerDetailsStackView
        passengerDetailsStackView.translatesAutoresizingMaskIntoConstraints = false
        passengerDetailsStackView.alignment = .center
        passengerDetailsStackView.axis = .vertical
        passengerDetailsStackView.distribution = .fill
        passengerDetailsStackView.spacing = 5.0
        
        return passengerDetailsStackView
    }()
    
    private lazy var passengerDetailsImage: UIImageView = {
        let passengerDetailsIcon = UIImageView()
        passengerDetailsIcon.accessibilityIdentifier = KHPassengerDetailsPaymentViewID.passengerDetailsImage
        passengerDetailsIcon.translatesAutoresizingMaskIntoConstraints = false
        passengerDetailsIcon.image = UIImage.uisdkImage("user_icon")
        passengerDetailsIcon.tintColor = KarhooUI.colors.secondary
        passengerDetailsIcon.contentMode = .scaleAspectFit
        
        return passengerDetailsIcon
    }()
    
    private lazy var passengerDetailsTitle: UILabel = {
        let passengerDetailsTitleLabel = UILabel()
        passengerDetailsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        passengerDetailsTitleLabel.accessibilityIdentifier = KHPassengerDetailsPaymentViewID.passengerDetailsTitle
        passengerDetailsTitleLabel.textColor = KarhooUI.colors.secondary
        passengerDetailsTitleLabel.textAlignment = .center
        passengerDetailsTitleLabel.text = UITexts.Booking.passenger
        passengerDetailsTitleLabel.font = KarhooUI.fonts.getBoldFont(withSize: 12.0)
        
        return passengerDetailsTitleLabel
    }()
    
    private lazy var passengerDetailsSubtitle: UILabel = {
        let passengerDetailsSubtitleLabel = UILabel()
        passengerDetailsSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        passengerDetailsSubtitleLabel.accessibilityIdentifier = KHPassengerDetailsPaymentViewID.passengerDetailsTitle
        passengerDetailsSubtitleLabel.textColor = KarhooUI.colors.accent
        passengerDetailsSubtitleLabel.textAlignment = .center
        passengerDetailsSubtitleLabel.text = UITexts.Booking.guestCheckoutPassengerDetailsTitle
        passengerDetailsSubtitleLabel.font = KarhooUI.fonts.getRegularFont(withSize: 10.0)
        
        return passengerDetailsSubtitleLabel
    }()
    
    var details: PassengerDetails?
    
    init() {
        super.init(frame: .zero)
        self.setupView()
    }
    
    convenience init(viewModel: QuoteViewModel) {
        self.init()
        self.set(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = KHPassengerDetailsPaymentViewID.container
        
        addSubview(stackView)
        
        passengerDetailsStackView.addArrangedSubview(passengerDetailsImage)
        passengerDetailsStackView.addArrangedSubview(passengerDetailsTitle)
        passengerDetailsStackView.addArrangedSubview(passengerDetailsSubtitle)

        passengerDetailsContainer.addSubview(passengerDetailsStackView)
        
        stackView.addArrangedSubview(passengerDetailsContainer)
        stackView.addArrangedSubview(passengerPaymentContainer)
    }
    
    override func updateConstraints() {
        if !didSetupConstraints {
            stackView.anchor(top: topAnchor,
                             leading: leadingAnchor,
                             trailing: trailingAnchor,
                             height: 92.0)
            
            passengerDetailsStackView.anchor(top: passengerDetailsContainer.topAnchor,
                                             leading: passengerDetailsContainer.leadingAnchor,
                                             bottom: passengerDetailsContainer.bottomAnchor,
                                             trailing: passengerDetailsContainer.trailingAnchor,
                                             paddingTop: 16.0,
                                             paddingBottom: 16.0)
            
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
    
    private func set(viewModel: QuoteViewModel) {
        // to be used when implementing logic for logged in user / token flows
    }
    
    @objc
    private func paymentViewTapped() {
        // todo: continue implementation
    }
    
    @objc
    private func passengerDetailsViewTapped() {
        // todo: continue implementation
    }
}
