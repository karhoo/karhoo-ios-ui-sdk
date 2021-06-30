//
//  KarhooAddressMapView.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK

final class KarhooAddressMapView: UIView, AddressMapView {
    
    private var map: MapView = KarhooMKMapView()
    private weak var actions: AddressMapActions?
    private var presenter: AddressMapPresenter?
    private var closeButton: UIButton!
    private var setLocationButton: UIButton!
    private var addressDisplayView: KarhooAddressDisplayView = KarhooAddressDisplayView()
    
    init() {
        super.init(frame: .zero)
        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setUpView() {

        map.translatesAutoresizingMaskIntoConstraints = false
        addSubview(map)
        
        NSLayoutConstraint.activate([
            map.widthAnchor.constraint(equalTo: widthAnchor),
            map.heightAnchor.constraint(equalTo: heightAnchor),
            map.centerXAnchor.constraint(equalTo: centerXAnchor),
            map.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        closeButton = UIButton(type: .custom)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.accessibilityIdentifier = "set_on_map_close"
        closeButton.isAccessibilityElement = true
        closeButton.setImage(UIImage.uisdkImage("cross"), for: .normal)
        closeButton.addTarget(self, action: #selector(didPressClose), for: .touchUpInside)
        closeButton.imageView?.contentMode = .scaleAspectFit
        closeButton.tintColor = .black
        addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            closeButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 60),
            closeButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        addressDisplayView.translatesAutoresizingMaskIntoConstraints = false
        addressDisplayView.layer.cornerRadius = Attributes.standardCornerRadius
        addSubview(addressDisplayView)
        
        NSLayoutConstraint.activate([
            addressDisplayView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 10),
            addressDisplayView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            addressDisplayView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            addressDisplayView.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor, constant: -10)
        ])
        
        setLocationButton = UIButton(type: .custom)
        setLocationButton.translatesAutoresizingMaskIntoConstraints = false
        setLocationButton.accessibilityIdentifier = "set_on_map_okay"
        setLocationButton.isAccessibilityElement = true
        let locationButtonImage = UIImage.uisdkImage("confirm").withRenderingMode(.alwaysTemplate)
        setLocationButton.setImage(locationButtonImage, for: .normal)
        setLocationButton.tintColor = KarhooUI.colors.secondary
        setLocationButton.addTarget(self, action: #selector(selectLocation), for: .touchUpInside)
        setLocationButton.imageView?.contentMode = .scaleAspectFit
        addSubview(setLocationButton)
        
        NSLayoutConstraint.activate([
            setLocationButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -26),
            setLocationButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -15),
            setLocationButton.widthAnchor.constraint(equalToConstant: 60),
            setLocationButton.heightAnchor.constraint(equalToConstant: 60)
        ])

        map.centerPin(hidden: false)
        
        let margin: CGFloat = 10
        let extraPadding: CGFloat = 10
        let addressBarBottom = (addressDisplayView.frame.maxY) + extraPadding * 2
        
        let padding = UIEdgeInsets(top: addressBarBottom,
                                   left: margin,
                                   bottom: -190,
                                   right: margin)
        map.set(padding: padding)
    }
    
    func set(actions: AddressMapActions,
             addressType: AddressType) {
        self.actions = actions
        presenter = KarhooAddressMapPresenter(view: self)
        setUpView(addressType: addressType)
        map.set(focusButtonHidden: true)
    }
    
    private func setUpView(addressType: AddressType) {
        addressDisplayView.set(addressType: addressType)
        if addressType == .pickup {
            map.set(centerIcon: "pickup_pin")
        } else {
            map.set(centerIcon: "dropoff_pin")
        }
    }
    
    func mapView() -> MapView {
        return map
    }
    
    func set(addressBarText: String) {
        addressDisplayView.set(address: addressBarText)
    }
    
    @objc
    func didPressClose() {
        actions?.closeAddressMapView()
    }
    
    @objc
    func selectLocation() {
        guard let lastLocation = presenter?.lastSelectedLocation() else {
            actions?.closeAddressMapView()
            return
        }
        actions?.addressMapSelected(location: lastLocation)
    }
}
