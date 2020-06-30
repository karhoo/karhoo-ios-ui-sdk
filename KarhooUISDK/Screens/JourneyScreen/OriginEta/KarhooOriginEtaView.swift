//
//  KarhooOriginEtaView.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo All rights reserved.
//

import UIKit

public struct KHOriginEtaViewID {
    public static let view = "origin_eta_view"
    public static let etaLabel = "eta_label"
    public static let minLabel = "min_label"
    public static let container = "container_view"
}

final class KarhooOriginEtaView: UIView, OriginEtaView {
    
    private var didSetupConstraint: Bool = false
    private var etaLabel: UILabel!
    private var minLabel: UILabel!
    private var containerView: UIView!
    private var presenter: OriginEtaPresenter!
    
    init() {
        super.init(frame: .zero)
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds,
                                        cornerRadius: min(containerView.bounds.width,
                                                          containerView.bounds.height) / 2).cgPath
        layer.shadowRadius = 5
        layer.shadowOffset = .zero
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    private func setUpView() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = KHOriginEtaViewID.view
        
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.accessibilityIdentifier = KHOriginEtaViewID.container
        containerView.isAccessibilityElement = false
        containerView.backgroundColor = KarhooUI.colors.white
        addSubview(containerView)
        
        etaLabel = UILabel()
        etaLabel.translatesAutoresizingMaskIntoConstraints = false
        etaLabel.accessibilityIdentifier = KHOriginEtaViewID.etaLabel
        etaLabel.isAccessibilityElement = true
        etaLabel.font = KarhooUI.fonts.titleBold()
        etaLabel.textColor = KarhooUI.colors.darkGrey
        etaLabel.textAlignment = .center
        containerView.addSubview(etaLabel)
        
        minLabel = UILabel()
        minLabel.translatesAutoresizingMaskIntoConstraints = false
        minLabel.accessibilityIdentifier = KHOriginEtaViewID.minLabel
        minLabel.isAccessibilityElement = true
        minLabel.text = UITexts.Generic.minutes
        minLabel.font = KarhooUI.fonts.bodyRegular()
        minLabel.textColor = KarhooUI.colors.medGrey
        minLabel.textAlignment = .center
        containerView.addSubview(minLabel)
        
        updateConstraints()
        presenter = KarhooOriginEtaPresenter(etaView: self)
    }
    
    override func updateConstraints() {
        if !didSetupConstraint {
            
            let containerSize: CGFloat = 50.0
            _ = [containerView.topAnchor.constraint(equalTo: topAnchor),
                 containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
                 containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
                 containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
                 containerView.widthAnchor.constraint(equalToConstant: containerSize),
                 containerView.heightAnchor.constraint(equalToConstant: containerSize)].map { $0.isActive = true }
            containerView.layer.cornerRadius = containerSize / 2
            containerView.layer.masksToBounds = true
            
            _ = [etaLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5.0),
                 etaLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                 etaLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                 etaLabel.bottomAnchor.constraint(equalTo: minLabel.topAnchor)].map { $0.isActive = true }
            
            _ = [minLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                 minLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                 minLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,
                                                  constant: -3.0)].map { $0.isActive = true }
            
            didSetupConstraint = true
        }
        super.updateConstraints()
    }
    
    func show(eta: String) {
        isHidden = false
        etaLabel.text = eta
        
        layer.shadowPath = nil
        setNeedsDisplay()
    }
    
    func hide() {
        isHidden = true
    }
    
    func start(tripId: String) {
        presenter.monitorTrip(tripId: tripId)
    }
    
    func stop() {
        presenter.stopMonitoringTrip()
    }
}
