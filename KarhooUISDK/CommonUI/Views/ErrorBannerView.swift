//
//  ErrorBannerView.swift
//  KarhooUISDK
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit

public struct KHErrorBannerViewID {
    public static let view = "error_banner_view"
    public static let errorMessage = "error_message_label"
    public static let dismissButton = "dismiss_button"
}

protocol ErrorBannerViewDelegate: class {
    func didTapOnDismiss(_ view: ErrorBannerView)
}

final class ErrorBannerView: UIView {
    
    private var didSetupConstraints: Bool = false
    private var messageTopConstant: CGFloat = 10.0
    private var messageBottomConstant: CGFloat = -10.0
    
    private var errorMessageLabel: UILabel!
    private var errorMessage: String?
    private var dismissButton: UIButton!
    private var duration: Double!
    private var color: UIColor = .red
    typealias  ErrorBannerViewHandler = (ErrorBannerView) -> Void
    private var action: ErrorBannerViewHandler?
    
   weak var delegate: ErrorBannerViewDelegate?
    
    init(withMessage message: String? = nil,
         duration: Double? = 5.0,
         color: UIColor = .red) {
        super.init(frame: .zero)
        self.errorMessage = message
        self.duration = duration
        self.color = color
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = KHErrorBannerViewID.view
        backgroundColor = color
        
        errorMessageLabel = UILabel()
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.accessibilityIdentifier = KHErrorBannerViewID.errorMessage
        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.textColor = KarhooUI.colors.white
        errorMessageLabel.text = errorMessage != nil ? errorMessage! : UITexts.Generic.errorMessage
        addSubview(errorMessageLabel)
        
        dismissButton = UIButton(type: .custom)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.accessibilityIdentifier = KHErrorBannerViewID.dismissButton
        dismissButton.addTarget(self, action: #selector(didTapOnDismiss), for: .touchUpInside)
        dismissButton.setImage(UIImage.uisdkImage("cross").withRenderingMode(.alwaysTemplate), for: .normal)
        dismissButton.tintColor = KarhooUI.colors.white
        addSubview(dismissButton)
        
        updateConstraints()
    }
    
    override func updateConstraints() {
        if !didSetupConstraints {
            
            _ = [errorMessageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30.0),
                 errorMessageLabel.topAnchor.constraint(equalTo: topAnchor,
                                                        constant: messageTopConstant +
                                                            UIApplication.shared.statusBarFrame.maxY),
                 errorMessageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: messageBottomConstant),
                 errorMessageLabel.trailingAnchor.constraint(lessThanOrEqualTo: dismissButton.leadingAnchor,
                                                             constant: -20.0)].map { $0.isActive = true }
            
            let buttonSize: CGFloat = 20.0
            _ = [dismissButton.widthAnchor.constraint(equalToConstant: buttonSize),
                 dismissButton.heightAnchor.constraint(equalToConstant: buttonSize),
                 dismissButton.centerYAnchor.constraint(equalTo: errorMessageLabel.centerYAnchor),
                 dismissButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.0)]
                .map { $0.isActive = true }
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    @objc
    private func didTapOnDismiss() {
        delegate?.didTapOnDismiss(self)
    }
    
    public func bannerViewDuration() -> Double {
        return duration
    }
}
