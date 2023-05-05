//
//  KarhooAddressMapView.swift
//  KarhooUISDK
//
//
//  Copyright © 2020 Karhoo. All rights reserved.
//

import Foundation
import KarhooSDK
import UIKit

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
        closeButton.setImage(UIImage.uisdkImage("kh_uisdk_cross"), for: .normal)
        closeButton.addTarget(self, action: #selector(didPressClose), for: .touchUpInside)
        closeButton.imageView?.contentMode = .scaleAspectFit
        closeButton.tintColor = KarhooUI.colors.text
        addSubview(closeButton)
        
        closeButton.anchor(top: safeAreaLayoutGuide.topAnchor, leading: safeAreaLayoutGuide.leadingAnchor, width: 60, height: 60)
        
        addressDisplayView.translatesAutoresizingMaskIntoConstraints = false
        addressDisplayView.layer.cornerRadius = Attributes.standardCornerRadius
        addSubview(addressDisplayView)
        
        addressDisplayView.anchor(top: closeButton.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10, height: 60)
        
        setLocationButton = UIButton(type: .custom)
        setLocationButton.translatesAutoresizingMaskIntoConstraints = false
        setLocationButton.accessibilityIdentifier = "set_on_map_okay"
        setLocationButton.isAccessibilityElement = true
        let locationButtonImage = UIImage.uisdkImage("kh_uisdk_confirm").withRenderingMode(.alwaysTemplate)
        setLocationButton.setImage(locationButtonImage, for: .normal)
        setLocationButton.tintColor = KarhooUI.colors.secondary
        setLocationButton.addTarget(self, action: #selector(selectLocation), for: .touchUpInside)
        setLocationButton.imageView?.contentMode = .scaleAspectFit
        addSubview(setLocationButton)
        
        setLocationButton.anchor(
            trailing: safeAreaLayoutGuide.trailingAnchor,
            bottom: safeAreaLayoutGuide.bottomAnchor,
            paddingRight: 15,
            paddingBottom: 26,
            width: 60,
            height: 60
        )

        map.centerPin(hidden: false)
        
        let margin: CGFloat = 10
        let extraPadding: CGFloat = 10
        let addressBarBottom = (addressDisplayView.frame.maxY) + extraPadding * 2
        
        let padding = UIEdgeInsets(top: addressBarBottom,
                                   left: margin,
                                   bottom: 0,
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
            map.set(
                centerIcon: PinAsset.pickup.rawValue,
                tintColor: KarhooUI.colors.primary,
                accessibilityLabel: UITexts.Accessibility.mapPickUpPin
            )
        } else {
            map.set(
                centerIcon: PinAsset.destination.rawValue,
                tintColor: KarhooUI.colors.secondary,
                accessibilityLabel: UITexts.Accessibility.mapDropOffPin
            )
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
