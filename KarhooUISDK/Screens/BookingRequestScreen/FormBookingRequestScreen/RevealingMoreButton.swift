//
//  LearnMoreButton.swift
//  KarhooUISDK
//
//  Created by Anca Feurdean on 18.08.2021.
//  Copyright © 2021 Flit Technologies Ltd. All rights reserved.
//

import UIKit

private enum ButtonMode {
    case learnMore
    case learnLess
}

//public struct KHBookingButtonViewID {
//    public static let view = "revealing_button_view"
//    public static let buttonTitle = "title_label"
//    public static let activity = "loading_indicator"
//    public static let image = "tick_image"
//    public static let button = "view_button"
//}

//final class RevealingMoreButton: UIButton {
//    private weak var actions: BookingButtonActions?
//    private var containerView: UIView!
//    private var activityIndicator: UIActivityIndicatorView!
//    private var button: UIButton!
//    private var tickImage: UIImageView!
//    private var buttonLabel: UILabel!
//    private var currentMode: ButtonMode?
//    private let textTransitionTime = 0.25
//    private var didSetupConstraints = false
//    private var guestBooking: Bool = false
//
//    init() {
//        super.init(frame: .zero)
//        self.setUpView()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setUpView() {
//        translatesAutoresizingMaskIntoConstraints = false
//        accessibilityIdentifier = KHBookingButtonViewID.view
//        
//        containerView = UIView()
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//        containerView.accessibilityIdentifier = KHBookingButtonViewID.container
//        containerView.backgroundColor = KarhooUI.colors.secondary
//        containerView.layer.cornerRadius = 8.0
//        containerView.layer.masksToBounds = true
//        addSubview(containerView)
//        
//        buttonLabel = UILabel()
//        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
//        buttonLabel.accessibilityIdentifier = KHBookingButtonViewID.buttonTitle
//        buttonLabel.font = KarhooUI.fonts.subtitleBold()
//        buttonLabel.textColor = KarhooUI.colors.white
//        buttonLabel.textAlignment = .center
//        containerView.addSubview(buttonLabel)
//        
//        activityIndicator = UIActivityIndicatorView(style: .white)
//        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
//        activityIndicator.accessibilityIdentifier = KHBookingButtonViewID.activity
//        activityIndicator.hidesWhenStopped = true
//        containerView.addSubview(activityIndicator)
//        
//        tickImage = UIImageView(image: UIImage.uisdkImage("tick").withRenderingMode(.alwaysTemplate))
//        tickImage.accessibilityIdentifier = KHBookingButtonViewID.image
//        tickImage.translatesAutoresizingMaskIntoConstraints = false
//        tickImage.tintColor = KarhooUI.colors.white
//        tickImage.contentMode = .scaleAspectFill
//        containerView.addSubview(tickImage)
//        
//        button = UIButton(type: .custom)
//        button.accessibilityIdentifier = KHBookingButtonViewID.button
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
//        containerView.addSubview(button)
//        
//        guestBooking = Karhoo.configuration.authenticationMethod().isGuest() ? true : false
//        
//        setRequestMode()
//    }
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.setUpView()
//    }
//    
//    override func updateConstraints() {
//        if !didSetupConstraints {
//            
//            _ = [containerView.topAnchor.constraint(equalTo: topAnchor),
//                 containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
//                 containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0),
//                 containerView.trailingAnchor.constraint(equalTo: trailingAnchor,
//                                                         constant: -20.0)].map { $0.isActive = true }
//            
//            _ = [buttonLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
//                 buttonLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
//                 buttonLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
//                 buttonLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)].map { $0.isActive = true }
//            
//            let activitySize: CGFloat = 20.0
//            _ = [activityIndicator.widthAnchor.constraint(equalToConstant: activitySize),
//                 activityIndicator.heightAnchor.constraint(equalToConstant: activitySize),
//                 activityIndicator.centerYAnchor.constraint(equalTo: buttonLabel.centerYAnchor),
//                 activityIndicator.trailingAnchor.constraint(equalTo: buttonLabel.leadingAnchor,
//                                                             constant: -12.0)].map { $0.isActive = true }
//            
//            let imageSize: CGFloat = 20.0
//            _ = [tickImage.widthAnchor.constraint(equalToConstant: imageSize),
//                 tickImage.heightAnchor.constraint(equalToConstant: imageSize),
//                 tickImage.centerYAnchor.constraint(equalTo: activityIndicator.centerYAnchor),
//                 tickImage.centerXAnchor.constraint(equalTo: activityIndicator.centerXAnchor)]
//                .map { $0.isActive = true }
//            
//            _ = [button.topAnchor.constraint(equalTo: topAnchor),
//                 button.leadingAnchor.constraint(equalTo: leadingAnchor),
//                 button.trailingAnchor.constraint(equalTo: trailingAnchor),
//                 button.bottomAnchor.constraint(equalTo: bottomAnchor)].map { $0.isActive = true }
//            
//            didSetupConstraints = true
//        }
//        
//        super.updateConstraints()
//    }
//
//    @objc
//    private func buttonTapped() {
//        guard let mode = currentMode else {
//            return
//        }
//
//        switch mode {
//        case .request: actions?.requestPressed()
//        case .addFlightDetails: actions?.addFlightDetailsPressed()
//        default: return
//        }
//    }
//
//    func set(actions: BookingButtonActions) {
//        self.actions = actions
//    }
//    
//    func setDisabledMode() {
//        currentMode = .disabled
//        containerView.backgroundColor = KarhooUI.colors.secondary.withAlphaComponent(0.5)
//        button.isEnabled = false
//    }
//
//    func setRequestMode() {
//        setSelectedState()
//        currentMode = .request
//        set(buttonTitle: UITexts.Booking.requestCar)
//        tickImage.isHidden = true
//        activityIndicator?.stopAnimating()
//    }
//
//    func setRequestingMode() {
//        currentMode = .requesting
//        button.isEnabled = false
//        containerView.backgroundColor = KarhooUI.colors.secondary
//        set(buttonTitle: UITexts.Booking.requestingCar)
//        tickImage.isHidden = true
//        activityIndicator?.startAnimating()
//    }
//
//    func setRequestedMode() {
//        setSelectedState()
//        currentMode = .requested
//        set(buttonTitle: UITexts.Booking.requestReceived)
//        tickImage?.isHidden = false
//        activityIndicator?.stopAnimating()
//    }
//
//    func setAddFlightDetailsMode() {
//        setSelectedState()
//        currentMode = .addFlightDetails
//        set(buttonTitle: UITexts.Airport.addFlightDetails)
//        tickImage.isHidden = true
//        activityIndicator?.stopAnimating()
//    }
//    
//    private func setSelectedState() {
//        containerView.backgroundColor = KarhooUI.colors.secondary
//        button.isEnabled = true
//    }
//
//    private func set(buttonTitle: String) {
//        UIView.transition(with: buttonLabel,
//                          duration: textTransitionTime,
//                          options: [.curveEaseInOut, .transitionCrossDissolve],
//                          animations: { [weak self] in
//                            self?.buttonLabel.text = buttonTitle
//        }, completion: nil)
//    }
//}
