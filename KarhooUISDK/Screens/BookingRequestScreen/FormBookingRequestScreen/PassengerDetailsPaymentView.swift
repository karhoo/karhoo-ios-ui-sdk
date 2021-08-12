//
//  PassengerDetailsPaymentView.swift
//  KarhooUISDK
//
//  Created by Anca Feurdean on 12.08.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import UIKit

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
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        
        return stackView
    }()
    
    private lazy var passengerDetailsContainer: UIView = {
        let passengerDetailsView = UIView()
        passengerDetailsView.accessibilityIdentifier = KHPassengerDetailsPaymentViewID.passengerDetailsContainer
        passengerDetailsView.layer.cornerRadius = 5.0
        passengerDetailsView.layer.borderColor = KarhooUI.colors.lightGrey.cgColor
        passengerDetailsView.layer.borderWidth = 0.5
        passengerDetailsView.layer.masksToBounds = true
        
        return passengerDetailsView
    }()
    
    private lazy var passengerPaymentContainer: UIView = {
        let passengerPaymentView = UIView()
        passengerPaymentView.accessibilityIdentifier = KHPassengerDetailsPaymentViewID.passengerDetailsContainer
        passengerPaymentView.layer.cornerRadius = 5.0
        passengerPaymentView.layer.borderColor = KarhooUI.colors.lightGrey.cgColor
        passengerPaymentView.layer.borderWidth = 0.5
        passengerPaymentView.layer.masksToBounds = true
        
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
    
    private lazy var passengerPaymentStackView: UIStackView = {
        let passengerPaymentStackView = UIStackView()
        passengerPaymentStackView.accessibilityIdentifier = KHPassengerDetailsPaymentViewID.passengerDetailsStackView
        passengerPaymentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        passengerPaymentStackView.alignment = .center
        passengerPaymentStackView.axis = .vertical
        passengerPaymentStackView.distribution = .fill
        passengerPaymentStackView.spacing = 5.0
        
        return passengerPaymentStackView
    }()
    
    private lazy var passengerDetailsImage: UIImageView = {
        let passengerDetailsIcon = UIImageView()
        passengerDetailsIcon.accessibilityIdentifier = KHPassengerDetailsPaymentViewID.passengerDetailsImage
        passengerDetailsIcon.translatesAutoresizingMaskIntoConstraints = false
        passengerDetailsIcon.image = UIImage.uisdkImage("info_icon")
        passengerDetailsIcon.tintColor = KarhooUI.colors.secondary
        passengerDetailsIcon.contentMode = .scaleAspectFit
        
        return passengerDetailsIcon
    }()
    
    private lazy var passengerPaymentImage: UIImageView = {
        let passengerPaymentIcon = UIImageView()
        passengerPaymentIcon.accessibilityIdentifier = KHPassengerDetailsPaymentViewID.passengerPaymentImage
        passengerPaymentIcon.translatesAutoresizingMaskIntoConstraints = false
        passengerPaymentIcon.image = UIImage.uisdkImage("info_icon")
        passengerPaymentIcon.tintColor = KarhooUI.colors.secondary
        passengerPaymentIcon.contentMode = .scaleAspectFit
        
        return passengerPaymentIcon
    }()
    
    private lazy var passengerDetailsTitle: UILabel = {
        let passengerDetailsTitleLabel = UILabel()
        passengerDetailsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        passengerDetailsTitleLabel.accessibilityIdentifier = KHPassengerDetailsPaymentViewID.passengerDetailsTitle
        passengerDetailsTitleLabel.textColor = KarhooUI.colors.secondary
        passengerDetailsTitleLabel.textAlignment = .right
        passengerDetailsTitleLabel.font = KarhooUI.fonts.getRegularFont(withSize: 12.0)
        
        return passengerDetailsTitleLabel
    }()
    
    private lazy var passengerPaymentTitle: UILabel = {
        let passengerPaymentTitleLabel = UILabel()
        passengerPaymentTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        passengerPaymentTitleLabel.accessibilityIdentifier = KHPassengerDetailsPaymentViewID.passengerPaymentTitle
        passengerPaymentTitleLabel.textColor = KarhooUI.colors.secondary
        passengerPaymentTitleLabel.textAlignment = .right
        passengerPaymentTitleLabel.font = KarhooUI.fonts.getRegularFont(withSize: 12.0)
        
        return passengerPaymentTitleLabel
    }()
    
    private lazy var passengerDetailsSubtitle: UILabel = {
        let passengerDetailsSubtitleLabel = UILabel()
        passengerDetailsSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        passengerDetailsSubtitleLabel.accessibilityIdentifier = KHPassengerDetailsPaymentViewID.passengerDetailsTitle
        passengerDetailsSubtitleLabel.textColor = KarhooUI.colors.accent
        passengerDetailsSubtitleLabel.textAlignment = .right
        passengerDetailsSubtitleLabel.font = KarhooUI.fonts.getRegularFont(withSize: 10.0)
        
        return passengerDetailsSubtitleLabel
    }()
    
    private lazy var passengerPaymentSubtitle: UILabel = {
        let passengerPaymentSubtitleLabel = UILabel()
        passengerPaymentSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        passengerPaymentSubtitleLabel.accessibilityIdentifier = KHPassengerDetailsPaymentViewID.passengerPaymentTitle
        passengerPaymentSubtitleLabel.textColor = KarhooUI.colors.accent
        passengerPaymentSubtitleLabel.textAlignment = .right
        passengerPaymentSubtitleLabel.font = KarhooUI.fonts.getRegularFont(withSize: 10.0)
        
        return passengerPaymentSubtitleLabel
    }()
    
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
        
        passengerDetailsContainer.addSubview(passengerDetailsStackView)
        passengerPaymentContainer.addSubview(passengerPaymentStackView)
        
        stackView.addSubview(passengerDetailsContainer)
        stackView.addSubview(passengerPaymentContainer)
    }
    
    override func updateConstraints() {}
}
