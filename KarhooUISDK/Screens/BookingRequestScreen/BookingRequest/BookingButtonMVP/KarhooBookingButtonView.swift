//
//  KarhooBookingButtonView.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit
import KarhooSDK

private enum ButtonMode {
    case requesting
    case requested
    case request
    case addFlightDetails
    case disabled
}

public struct KHBookingButtonViewID {
    public static let view = "booking_button_view"
    public static let container = "container_view"
    public static let buttonTitle = "title_label"
    public static let activity = "loading_indicator"
    public static let image = "tick_image"
    public static let button = "view_button"
}

final class KarhooBookingButtonView: UIView, BookingButtonView {

    private weak var actions: BookingButtonActions?
    private var containerView: UIView!
    private var activityIndicator: UIActivityIndicatorView!
    private var button: UIButton!
    private var tickImage: UIImageView!
    private var buttonLabel: UILabel!
    private var currentMode: ButtonMode?
    private let textTransitionTime = 0.25
    private var didSetupConstraints = false
    private var guestBooking: Bool = false

    init() {
        super.init(frame: .zero)
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = KHBookingButtonViewID.view
        
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.accessibilityIdentifier = KHBookingButtonViewID.container
        containerView.backgroundColor = KarhooUI.colors.secondary
        containerView.layer.cornerRadius = 8.0
        containerView.layer.masksToBounds = true
        addSubview(containerView)
        
        buttonLabel = UILabel()
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonLabel.accessibilityIdentifier = KHBookingButtonViewID.buttonTitle
        buttonLabel.font = KarhooUI.fonts.subtitleBold()
        buttonLabel.textColor = KarhooUI.colors.white
        buttonLabel.textAlignment = .center
        containerView.addSubview(buttonLabel)
        
        activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.accessibilityIdentifier = KHBookingButtonViewID.activity
        activityIndicator.hidesWhenStopped = true
        containerView.addSubview(activityIndicator)
        
        tickImage = UIImageView(image: UIImage.uisdkImage("tick").withRenderingMode(.alwaysTemplate))
        tickImage.accessibilityIdentifier = KHBookingButtonViewID.image
        tickImage.translatesAutoresizingMaskIntoConstraints = false
        tickImage.tintColor = KarhooUI.colors.white
        tickImage.contentMode = .scaleAspectFill
        containerView.addSubview(tickImage)
        
        button = UIButton(type: .custom)
        button.accessibilityIdentifier = KHBookingButtonViewID.button
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        containerView.addSubview(button)
        
        guestBooking = Karhoo.configuration.authenticationMethod().isGuest() ? true : false
        
        setRequestMode()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpView()
    }
    
    override func updateConstraints() {
        if !didSetupConstraints {
            
            containerView.anchor(top: topAnchor,
                                 leading: leadingAnchor,
                                 bottom: bottomAnchor,
                                 trailing: trailingAnchor,
                                 paddingLeft: 20.0,
                                 paddingRight: 20.0)

            buttonLabel.centerX(inView: self)
            buttonLabel.centerY(inView: self)
            buttonLabel.anchor(top: topAnchor,
                               bottom: bottomAnchor,
                               paddingTop: 10.0,
                               paddingBottom: 10.0)
            
            let activitySize: CGFloat = 20.0
            activityIndicator.anchor(trailing: buttonLabel.leadingAnchor,
                                     paddingRight: 12.0,
                                     width: activitySize,
                                     height: activitySize)
            activityIndicator.centerY(inView: buttonLabel)

            let imageSize: CGFloat = 20.0
            tickImage.centerX(inView: activityIndicator)
            tickImage.centerY(inView: activityIndicator)
            tickImage.anchor(width: imageSize,
                             height: imageSize)

            button.anchor(top: topAnchor,
                          leading: leadingAnchor,
                          bottom: bottomAnchor,
                          trailing: trailingAnchor)

            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }

    @objc
    private func buttonTapped() {
        guard let mode = currentMode else {
            return
        }

        switch mode {
        case .request: actions?.requestPressed()
        case .addFlightDetails: actions?.addFlightDetailsPressed()
        default: return
        }
    }

    func set(actions: BookingButtonActions) {
        self.actions = actions
    }
    
    func setDisabledMode() {
        currentMode = .disabled
        containerView.backgroundColor = KarhooUI.colors.secondary.withAlphaComponent(0.5)
        button.isEnabled = false
    }

    func setRequestMode() {
        setSelectedState()
        currentMode = .request
        set(buttonTitle: UITexts.Booking.requestCar.uppercased())
        tickImage.isHidden = true
        activityIndicator?.stopAnimating()
    }

    func setRequestingMode() {
        currentMode = .requesting
        button.isEnabled = false
        containerView.backgroundColor = KarhooUI.colors.secondary
        set(buttonTitle: UITexts.Booking.requestingCar.uppercased())
        tickImage.isHidden = true
        activityIndicator?.startAnimating()
    }

    func setRequestedMode() {
        setSelectedState()
        currentMode = .requested
        set(buttonTitle: UITexts.Booking.requestReceived.uppercased())
        tickImage?.isHidden = false
        activityIndicator?.stopAnimating()
    }

    func setAddFlightDetailsMode() {
        setSelectedState()
        currentMode = .addFlightDetails
        set(buttonTitle: UITexts.Airport.addFlightDetails)
        tickImage.isHidden = true
        activityIndicator?.stopAnimating()
    }
    
    private func setSelectedState() {
        containerView.backgroundColor = KarhooUI.colors.secondary
        button.isEnabled = true
    }

    private func set(buttonTitle: String) {
        UIView.transition(with: buttonLabel,
                          duration: textTransitionTime,
                          options: [.curveEaseInOut, .transitionCrossDissolve],
                          animations: { [weak self] in
                            self?.buttonLabel.text = buttonTitle
        }, completion: nil)
    }
}
