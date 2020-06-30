//
//  RideDetailsViewContainer.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import UIKit

final class RideDetailsViewContainer: UIView {

    private var viewContainer: UIView!
    private var stackContainer: UIStackView!
    public var tripDetailsView: TripDetailsView!
    public var tripMetaDataView: KarhooTripMetaDataView!
    public var stackButtonView: KarhooStackButtonView!
    
    public init() {
        super.init(frame: .zero)
        self.setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        addContainerOuterShadow()
    }
    
    private func setUpView() {
        
        accessibilityIdentifier = "ride_details_view"
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        
        viewContainer = UIView()
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.backgroundColor = .white
        addSubview(viewContainer)
        _ = [viewContainer.topAnchor.constraint(equalTo: self.topAnchor),
             viewContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor),
             viewContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor),
             viewContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor)].map { $0.isActive = true}
        
        viewContainer.layer.cornerRadius = 5
        viewContainer.layer.borderColor = UIColor.lightGray.cgColor
        viewContainer.layer.borderWidth = 1.0
        viewContainer.layer.masksToBounds = true
        
        stackContainer = UIStackView()
        stackContainer.axis = .vertical
        stackContainer.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(stackContainer)
        _ = [stackContainer.topAnchor.constraint(equalTo: viewContainer.topAnchor),
             stackContainer.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
             stackContainer.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor),
             stackContainer.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 20.0)]
            .map { $0.isActive = true }
        
        tripDetailsView = TripDetailsView()
        tripDetailsView.isBottomLineSeparatorHidden(false)
        stackContainer.addArrangedSubview(tripDetailsView)
        _ = [tripDetailsView.topAnchor.constraint(equalTo: viewContainer.topAnchor),
             tripDetailsView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
             tripDetailsView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor)]
            .map { $0.isActive = true }
        
        tripMetaDataView = KarhooTripMetaDataView()
        stackContainer.addArrangedSubview(tripMetaDataView)
        _ = [tripMetaDataView.topAnchor.constraint(equalTo: tripDetailsView.bottomAnchor),
             tripMetaDataView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
             tripMetaDataView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor)]
            .map { $0.isActive = true }
        
        stackButtonView = KarhooStackButtonView()
        stackContainer.addArrangedSubview(stackButtonView)
        _ = [stackButtonView.topAnchor.constraint(equalTo: tripMetaDataView.bottomAnchor),
             stackButtonView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
             stackButtonView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor),
             stackButtonView.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor)].map { $0.isActive = true }
    }
    
    func addContainerOuterShadow() {
        if layer.shadowPath == nil {
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.5
            layer.shadowPath = UIBezierPath(rect: bounds).cgPath
            layer.shadowRadius = 5
            layer.shadowOffset = .zero
            layer.shouldRasterize = true
            layer.rasterizationScale = UIScreen.main.scale
        }
    }

    public func updateViewLayers() {
        layer.shadowPath = nil
        setNeedsDisplay()
    }
}
