//
//  LoadingView.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit

public final class LoadingView: UIView {
    
    private var loadingLabel: UILabel!
    private var activityIndicatorView: UIActivityIndicatorView!
    private let animationDuration = 0.2
    internal var shouldHideWhenAlphaZero: Bool = false
    private var backgroundAlpha: CGFloat?
    private var didSetupConstraints: Bool = false
    
    public init(shouldHideWhenAlphaZero: Bool = false) {
        super.init(frame: .zero)
        self.shouldHideWhenAlphaZero = shouldHideWhenAlphaZero
        setUpView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    private func setUpView() {
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = "loading_view"
        alpha = 0.0
        
        activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicatorView.accessibilityIdentifier = "activity_indicator"
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.startAnimating()
        addSubview(activityIndicatorView)
        
        loadingLabel = UILabel(frame: .zero)
        loadingLabel.accessibilityIdentifier = "loading_label"
        loadingLabel.textAlignment = .center
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingLabel.font = KarhooUI.fonts.bodyBold()
        loadingLabel.textColor = KarhooUI.colors.offWhite // to be confirmed
        
        addSubview(loadingLabel)
    }
    
    public override func updateConstraints() {
        if !didSetupConstraints {
            _ = [activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
                 activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)].map { $0.isActive = true }
            
            _ = [loadingLabel.topAnchor.constraint(equalTo: activityIndicatorView.bottomAnchor, constant: 8.0),
                 loadingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0),
                 loadingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.0),
                 loadingLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8.0)].map { $0.isActive = true }
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    public func initialLoadingState() {
        alpha = 0
    }
    
    public func set(loadingText: String) {
        loadingLabel.text = loadingText
    }
    
    public func set(backgroundColor: UIColor,
                    alpha: CGFloat = 1) {
        self.backgroundColor = backgroundColor
        backgroundAlpha = alpha
    }
    
    public func set(activityIndicatorColor: UIColor) {
        activityIndicatorView.color = activityIndicatorColor
    }
    
    public func show() {
        isHidden = false
        UIView.animate(withDuration: animationDuration, animations: { [weak self] in
            self?.alpha = self?.backgroundAlpha ?? 1
        })
    }
    
    public func hide() {
        UIView.animate(withDuration: animationDuration,
                       animations: { [weak self] in
                        self?.alpha = 0.0
            },
                       completion: { [weak self] _ in
                        if self?.shouldHideWhenAlphaZero == true {
                            self?.isHidden = true
                        }
        })
    }
    
    public func shouldHideWhenAlphaZero(_ value: Bool) {
        shouldHideWhenAlphaZero = value
    }
}
