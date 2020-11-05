//
//  KarhooDestinationEtaView.swift
//  Karhoo
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

public struct KHDestinationEtaViewID {
    public static let view = "destination_eta_view"
    public static let etaLabel = "destination_eta_label"
    public static let arrivalLabel = "destination_arrival_label"
}

final class KarhooDestinationEtaView: UIView, DestinationEtaView {
    
    private var didSetupConstraint: Bool = false
    private var containerView: UIView!
    private var arrivalLabel: UILabel!
    private var etaLabel: UILabel!
    
    private var presenter: DestinationEtaPresenter!
    
    init() {
        super.init(frame: .zero)
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        addOuterShadow()
    }
    
    private func setUpView() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = KHDestinationEtaViewID.view
        
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 4
        containerView.layer.masksToBounds = true
        containerView.backgroundColor = KarhooUI.colors.white
        addSubview(containerView)
        
        arrivalLabel = UILabel()
        arrivalLabel.translatesAutoresizingMaskIntoConstraints = false
        arrivalLabel.accessibilityIdentifier = KHDestinationEtaViewID.arrivalLabel
        arrivalLabel.font = KarhooUI.fonts.captionRegular()
        arrivalLabel.textColor = KarhooUI.colors.medGrey
        arrivalLabel.text = UITexts.Trip.arrival
        arrivalLabel.textAlignment = .center
        containerView.addSubview(arrivalLabel)
        
        etaLabel = UILabel()
        etaLabel.translatesAutoresizingMaskIntoConstraints = false
        etaLabel.accessibilityIdentifier = KHDestinationEtaViewID.etaLabel
        etaLabel.font = KarhooUI.fonts.headerBold()
        etaLabel.textColor = KarhooUI.colors.darkGrey
        etaLabel.textAlignment = .center
        containerView.addSubview(etaLabel)
        
        updateConstraints()
        presenter = KarhooDestinationEtaPresenter(etaView: self)
    }
    
    override func updateConstraints() {
        if !didSetupConstraint {
            
            _ = [containerView.topAnchor.constraint(equalTo: topAnchor),
                 containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
                 containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
                 containerView.bottomAnchor.constraint(equalTo: bottomAnchor)].map { $0.isActive = true }
            
            _ = [arrivalLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 3.0),
                 arrivalLabel.centerXAnchor.constraint(equalTo: etaLabel.centerXAnchor)].map { $0.isActive = true }
            
            _ = [etaLabel.topAnchor.constraint(equalTo: arrivalLabel.bottomAnchor, constant: 3.0),
                 etaLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8.0),
                 etaLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8.0),
                 etaLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,
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
